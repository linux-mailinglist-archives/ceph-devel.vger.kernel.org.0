Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE3387BE06A
	for <lists+ceph-devel@lfdr.de>; Mon,  9 Oct 2023 15:39:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377332AbjJINjv (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 9 Oct 2023 09:39:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376990AbjJINjt (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 9 Oct 2023 09:39:49 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99BBECA;
        Mon,  9 Oct 2023 06:39:45 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 375001F390;
        Mon,  9 Oct 2023 13:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1696858784; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rhhdrKYTtCPVKmKC9S4vTagGuNFEkueMHImZJv8X2YM=;
        b=Bt2zpHEqyPysxVZ5M3oLzODYBREFlRdKXZCNTkUo5nVnjolyHlKTSqsHc0wLt16UCUCoGV
        o5FSHr52+c41Zqh0WgU4xpr57lKbxluxV9MsWLeduU3KW8/IGZ+vIixQmZoqb9duTpD/Yg
        ln7PX4IFxS3p2paY1+N7RW4CAH7mVCc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1696858784;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rhhdrKYTtCPVKmKC9S4vTagGuNFEkueMHImZJv8X2YM=;
        b=GTPpcXs5FZVOBc6rMbaoAuxBJfWVKABL547gd9V7aCeCaeAzRhzXPGiNrLxWRqqimAkxCc
        9haxXwyqCBAkXlCA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id BF5BD13586;
        Mon,  9 Oct 2023 13:39:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id BYk7K58CJGUFcQAAMHmgww
        (envelope-from <lhenriques@suse.de>); Mon, 09 Oct 2023 13:39:43 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id 651cf113;
        Mon, 9 Oct 2023 13:39:38 +0000 (UTC)
From:   Luis Henriques <lhenriques@suse.de>
To:     Dan Carpenter <dan.carpenter@linaro.org>
Cc:     Xiubo Li <xiubli@redhat.com>, Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] ceph: fix type promotion bug on 32bit systems
In-Reply-To: <5e0418d3-a31b-4231-80bf-99adca6bcbe5@moroto.mountain> (Dan
        Carpenter's message of "Sat, 7 Oct 2023 11:52:39 +0300")
References: <5e0418d3-a31b-4231-80bf-99adca6bcbe5@moroto.mountain>
Date:   Mon, 09 Oct 2023 14:39:38 +0100
Message-ID: <87sf6jrk2t.fsf@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Dan Carpenter <dan.carpenter@linaro.org> writes:

> In this code "ret" is type long and "src_objlen" is unsigned int.  The
> problem is that on 32bit systems, when we do the comparison signed longs
> are type promoted to unsigned int.  So negative error codes from
> do_splice_direct() are treated as success instead of failure.
>
> Fixes: 1b0c3b9f91f0 ("ceph: re-org copy_file_range and fix some error pat=
hs")
> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
> ---
> 32bit is so weird and ancient.  It's strange to think that unsigned int
> has more positive bits than signed long.

Yikes! Thanks for catching this, Dan.  Really tricky.  I guess you used
some static analysis tool (smatch?) to highlight this issue for you,
right?

Anyway, feel free to add my

Reviewed-by: Luis Henriques <lhenriques@suse.de>

Cheers,
--=20
Lu=C3=ADs


>
> fs/ceph/file.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index b1da02f5dbe3..b5f8038065d7 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -2969,7 +2969,7 @@ static ssize_t __ceph_copy_file_range(struct file *=
src_file, loff_t src_off,
>  		ret =3D do_splice_direct(src_file, &src_off, dst_file,
>  				       &dst_off, src_objlen, flags);
>  		/* Abort on short copies or on error */
> -		if (ret < src_objlen) {
> +		if (ret < (long)src_objlen) {
>  			dout("Failed partial copy (%zd)\n", ret);
>  			goto out;
>  		}
> --=20
>
> 2.39.2
>
