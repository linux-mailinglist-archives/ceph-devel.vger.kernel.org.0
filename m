Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 927AC79BD10
	for <lists+ceph-devel@lfdr.de>; Tue, 12 Sep 2023 02:15:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237163AbjIKWJA (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 11 Sep 2023 18:09:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236281AbjIKKHz (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 11 Sep 2023 06:07:55 -0400
Received: from mxex1.tik.uni-stuttgart.de (mxex1.tik.uni-stuttgart.de [129.69.192.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2300C101
        for <ceph-devel@vger.kernel.org>; Mon, 11 Sep 2023 03:07:46 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mxex1.tik.uni-stuttgart.de (Postfix) with ESMTP id E9883610F8;
        Mon, 11 Sep 2023 12:07:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=uni-stuttgart.de;
         h=content-transfer-encoding:content-type:content-type
        :in-reply-to:from:from:references:content-language:subject
        :subject:user-agent:mime-version:date:date:message-id; s=dkim;
         i=@sec.uni-stuttgart.de; t=1694426858; x=1696165659; bh=bBFQ83n
        90FsEBE16+ONgWIwpFkOk8bcNypIDY0xosgg=; b=cl4vYL0xWaCBLGAOiNwmk2u
        1+bvCD8ynSEPVgOEylfQjH/gaVUnOkhI9RoPiKzeowPplQesHtw+YcA09HJSKAc4
        3nIc8/bOWz3PjQSl42gFuU7vt9LR8Q3WzjFLDYLpJGxRBY0iP83FCtdy+/jVgxXR
        0LI7aIvXPfF0D3L9ZXND6U8lThGZdc9XuA+fH9YkLqUs4mXO7fVNumKvp6Qvl0i9
        nvAjDy5wgLsCYvAPrlz/yHfEta0DsmlKgvum67f2np5FIKWL0fS2oyzE+ct8Jqng
        O9npFwABWrLfPAZWSNvK5SdtL3IUoianuY9CiKkexaVnqyvz1Maus+Fb7TW3lDQ=
        =
X-Virus-Scanned: USTUTT mailrelay AV services at mxex1.tik.uni-stuttgart.de
Received: from mxex1.tik.uni-stuttgart.de ([127.0.0.1])
 by localhost (mxex1.tik.uni-stuttgart.de [127.0.0.1]) (amavis, port 10031)
 with ESMTP id t5XvSZ6tZrxK; Mon, 11 Sep 2023 12:07:38 +0200 (CEST)
Received: from authenticated client
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mxex1.tik.uni-stuttgart.de (Postfix) with ESMTPSA
Message-ID: <a9b51955-0f27-d802-4716-988af03a25e9@sec.uni-stuttgart.de>
Date:   Mon, 11 Sep 2023 12:07:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [PATCH] ceph: fail the open_by_handle_at() if the dentry is being
 unlinked
Content-Language: en-US
To:     Xiubo Li <xiubli@redhat.com>
Cc:     ceph-devel@vger.kernel.org
References: <20220804080624.14768-1-xiubli@redhat.com>
 <e60ea973-d323-1d4d-c03b-0ee4779735c4@sec.uni-stuttgart.de>
 <3f6b622d-8513-f289-5146-546c1f747e10@redhat.com>
 <6dc123eb-7251-03a6-87ce-abe11925e2e3@sec.uni-stuttgart.de>
 <53c5733b-8a94-66e3-4d05-97238d147d5b@redhat.com>
From:   Sebastian Hasler <sebastian.hasler@sec.uni-stuttgart.de>
In-Reply-To: <53c5733b-8a94-66e3-4d05-97238d147d5b@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 11/09/2023 05:21, Xiubo Li wrote:

> "This will generally not work if the file  has  a  link  count of 
> zero  (files  created  with  O_TMPFILE  and without O_EXCL are an 
> exception)."
In this sentence, "generally" probably means "typically", so it depends 
on the specific file system's behavior. I don't know the CephFS behavior 
in this case. However, at least files created with O_TMPFILE are an 
exception. Does CephFS support creating files with O_TMPFILE? Such files 
can (and often will) go from the unlinked and open state to the linked 
and closed state.

-- 
Sebastian Hasler, M.Sc.
Institute of Information Security - SEC
University of Stuttgart
Universitätsstraße 38
D-70569 Stuttgart
Germany
https://sec.uni-stuttgart.de
Phone: +49 (0) 711 685 88208

