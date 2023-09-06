Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2132D7941D2
	for <lists+ceph-devel@lfdr.de>; Wed,  6 Sep 2023 19:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242420AbjIFRGp (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 6 Sep 2023 13:06:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233048AbjIFRGo (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 6 Sep 2023 13:06:44 -0400
X-Greylist: delayed 490 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 06 Sep 2023 10:06:39 PDT
Received: from mxex2.tik.uni-stuttgart.de (mxex2.tik.uni-stuttgart.de [129.69.192.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5926313E
        for <ceph-devel@vger.kernel.org>; Wed,  6 Sep 2023 10:06:39 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mxex2.tik.uni-stuttgart.de (Postfix) with ESMTP id 7AE8760EC7;
        Wed,  6 Sep 2023 18:58:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=uni-stuttgart.de;
         h=content-transfer-encoding:content-type:content-type
        :in-reply-to:content-language:references:subject:subject:from
        :from:user-agent:mime-version:date:date:message-id; s=dkim; i=
        @sec.uni-stuttgart.de; t=1694019501; x=1695758302; bh=lO6JYrZ/c/
        sjHeqUK84E63kpIlgSGGQjcTi6e9bezAY=; b=jM3qJr7VJKgnyYa+65w09qvpV4
        XaqcD+mFJzYNx/eMbGJRJwvjD4aYgB/bY1yoJ/R2WksA6B1w7/uDKFlDT6L0HLNY
        29kS/9c2Tyt8cdmo9XlCMAdppt/UG5P3SaMtD5CimD0Re1QORPEJIiIA2hFCjWDa
        9SdmSBxnB06yJhGwRwcgTceOErEu+h+iMQlkx4semTgKM/Ii9Q7f7kriKCxvwzHL
        szQ76YJZztrluS4FhEJPoSMHCsBE/j+W/a4s/ghwkxxZEM0Psoz5wd07fUc1gWm3
        MC3HPYiSQjYcsYE1Fk+RKSS4FFlvEJITQc/u+/UDnOLsZi5MLeRSnVQtI5NQ==
X-Virus-Scanned: USTUTT mailrelay AV services at mxex2.tik.uni-stuttgart.de
Received: from mxex2.tik.uni-stuttgart.de ([127.0.0.1])
 by localhost (mxex2.tik.uni-stuttgart.de [127.0.0.1]) (amavis, port 10031)
 with ESMTP id C3_ER3oX8KOD; Wed,  6 Sep 2023 18:58:21 +0200 (CEST)
Received: from authenticated client
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mxex2.tik.uni-stuttgart.de (Postfix) with ESMTPSA
Message-ID: <e60ea973-d323-1d4d-c03b-0ee4779735c4@sec.uni-stuttgart.de>
Date:   Wed, 6 Sep 2023 18:58:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
From:   Sebastian Hasler <sebastian.hasler@sec.uni-stuttgart.de>
Subject: Re: [PATCH] ceph: fail the open_by_handle_at() if the dentry is being
 unlinked
To:     xiubli@redhat.com
Cc:     ceph-devel@vger.kernel.org
References: <20220804080624.14768-1-xiubli@redhat.com>
Content-Language: en-US
In-Reply-To: <20220804080624.14768-1-xiubli@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

While reviewing the implementation of __fh_to_dentry (in the CephFS 
client), I noticed a possible race condition.

Linux has a syscall linkat(2) which allows, given an open file 
descriptor, to create a link for the file. So an inode that is unlinked 
can become linked.

Now the problem: The line ((inode->i_nlink == 0) && 
!__ceph_is_file_opened(ci)) performs two checks. If, in between those 
checks, the file goes from the unlinked and open state to the linked and 
closed state, then we return -ESTALE even though the inode is linked. I 
don't think this is the intended behavior. I guess this (going from 
unlinked and open to linked and closed) can happen when a concurrent 
process calls linkat() and then close().

