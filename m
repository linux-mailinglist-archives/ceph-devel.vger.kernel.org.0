Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ED23505C4C
	for <lists+ceph-devel@lfdr.de>; Mon, 18 Apr 2022 18:12:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346035AbiDRQOi (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 18 Apr 2022 12:14:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346033AbiDRQOi (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 18 Apr 2022 12:14:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ACAE27162
        for <ceph-devel@vger.kernel.org>; Mon, 18 Apr 2022 09:11:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2DFD7B80FCD
        for <ceph-devel@vger.kernel.org>; Mon, 18 Apr 2022 16:11:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C7D8C385A7;
        Mon, 18 Apr 2022 16:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650298315;
        bh=R9qqMR0EG+AdVl2C/IgYWwDOtURV/3V0QhFTVDO8vk4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ZOrvKOddnJauoojxUGWGKB5AqOvczFxaWEs8Ingzamb56xwRAJNe7Bf80g7VDtIEI
         7CNSXVsxxIahaHqdAXYLGo2L+ky4QvaE6ojSX/GKJxQKoC1xmlZYpYJijof12AGzIs
         fLn1aiT7Yc6DwRRRXN9oQnA1UO1GHdjPeO27Wh0l/eEAkZeAbBzqYHy2Cem6KcEReZ
         1L5eMkb8/D7j2nyFfFUJ+/M4JUC4CbCmddPPBIqbgOJ9yYqhbNA6Oezf6HWoQEabmq
         lL4MoB9WxAwCG53ZEnTKEKbkeWAxN+YEen2KteemsrXZuhre2NEh0Lo4m++51Gdt67
         nhytA6eE0QXsg==
Message-ID: <7a9691250bf47f3ea824cb9f2b51e4dd56d33327.camel@kernel.org>
Subject: Re: [PATCH v3 0/3] ceph: misc fix size truncate for fscrypt
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     idryomov@gmail.com, vshankar@redhat.com, lhenriques@suse.de,
        ceph-devel@vger.kernel.org
Date:   Mon, 18 Apr 2022 12:11:53 -0400
In-Reply-To: <20220412070745.22795-1-xiubli@redhat.com>
References: <20220412070745.22795-1-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2022-04-12 at 15:07 +0800, Xiubo Li wrote:
> Hi Jeff,
> 
> This series could be squashed into the same previous commit:
> 
> e90dc20d37a3 ceph: add truncate size handling support for fscrypt
> 
> 
> V3:
> - fix possible kunmaping random vaddr bug, thanks Luis.
> 
> V2:
> - remove the filemap lock related patch.
> - fix caps reference leakage
> 
> 
> 
> Xiubo Li (3):
>   ceph: flush small range instead of the whole map for truncate
>   ceph: fix caps reference leakage for fscrypt size truncating
>   ceph: fix possible kunmaping random vaddr
> 
>  fs/ceph/inode.c | 16 +++++++++++-----
>  1 file changed, 11 insertions(+), 5 deletions(-)
> 

Thanks Xiubo, this all looks good. I'll merge them into wip-fscrypt
soon.

Cheers!
-- 
Jeff Layton <jlayton@kernel.org>
