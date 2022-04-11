Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 826264FC25E
	for <lists+ceph-devel@lfdr.de>; Mon, 11 Apr 2022 18:29:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348603AbiDKQcA (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 11 Apr 2022 12:32:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348602AbiDKQb6 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 11 Apr 2022 12:31:58 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6580E5FA3
        for <ceph-devel@vger.kernel.org>; Mon, 11 Apr 2022 09:29:41 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 2498F1F38D;
        Mon, 11 Apr 2022 16:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1649694580; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=COQpjZIeNXmIaP9jVFqBpG8sM4POQzEIHiib750Apqc=;
        b=vCsEY0TNtRib7C9I8j3/uEyH2PvOpaB9H1xWbT45xwfjYDc4ucPWxH/N3e5SOipcYDKDI2
        dvlPiwOsPLA0KpPH9dhC6ImiruGRuJ54LPdP5ij91d7Wx9zpPJVbG6RriwTltT/obKsAIW
        y9IRQ7yJwQS+zMT/oz3GB+mEN6aoUQw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1649694580;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=COQpjZIeNXmIaP9jVFqBpG8sM4POQzEIHiib750Apqc=;
        b=/7ur0jzBQ5JG23yV+/fVM6H4kmPZ4Hzs7ycxll794/rRYMDIcB64S9RDVSQF7tvEvbp7tW
        1YdDw/rODV5ZvlBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B5AEE13A93;
        Mon, 11 Apr 2022 16:29:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id UTcWKXNXVGI9egAAMHmgww
        (envelope-from <lhenriques@suse.de>); Mon, 11 Apr 2022 16:29:39 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id 52a1e85f;
        Mon, 11 Apr 2022 16:30:05 +0000 (UTC)
Date:   Mon, 11 Apr 2022 17:30:05 +0100
From:   =?iso-8859-1?Q?Lu=EDs?= Henriques <lhenriques@suse.de>
To:     xiubli@redhat.com
Cc:     jlayton@kernel.org, idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] ceph: fix caps reference leakage for fscrypt size
 truncating
Message-ID: <YlRXjaKIX/cDeZqP@suse.de>
References: <20220411001426.251679-1-xiubli@redhat.com>
 <20220411001426.251679-3-xiubli@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220411001426.251679-3-xiubli@redhat.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Apr 11, 2022 at 08:14:26AM +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/inode.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index a2ff964e332b..6788a1f88eb6 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -2301,7 +2301,6 @@ static int fill_fscrypt_truncate(struct inode *inode,
>  
>  	pos = orig_pos;
>  	ret = __ceph_sync_read(inode, &pos, &iter, &retry_op, &objver);
> -	ceph_put_cap_refs(ci, got);
>  	if (ret < 0)
>  		goto out;
>  
> @@ -2365,6 +2364,7 @@ static int fill_fscrypt_truncate(struct inode *inode,
>  out:
>  	dout("%s %p size dropping cap refs on %s\n", __func__,
>  	     inode, ceph_cap_string(got));
> +	ceph_put_cap_refs(ci, got);
>  	kunmap_local(iov.iov_base);
>  	if (page)
>  		__free_pages(page, 0);
> -- 
> 2.27.0
> 

If the plan is to squash this into commit "ceph: add truncate size
handling support for fscrypt" it may be worth also fix the
kmap_local_page()/kunmap_local() as the first few 'goto out' jumps
shouldn't be doing the kunmap.

Cheers,
--
Luís
