Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9ABFC7237AD
	for <lists+ceph-devel@lfdr.de>; Tue,  6 Jun 2023 08:27:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235135AbjFFG1w (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 6 Jun 2023 02:27:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234678AbjFFG11 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 6 Jun 2023 02:27:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 751E110F4
        for <ceph-devel@vger.kernel.org>; Mon,  5 Jun 2023 23:25:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686032741;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Sc0k4E/CK5JAlKaQympAoeo/zs2zKPHL4AXiAHVoqIs=;
        b=dYy2BadhHNngKIjvyCwEYTvAwADa/ZlAdeQRhh44U5HfxduL/afWnOMYl42R6JL7TjkOwh
        HxLj0OkJveIS8ZWHXaqTxv1YVZS8mb/hSi1BrT2gR9J3yy0sxrpT2QDr4DP4aopB0B/7Ys
        sH6GgopVL+SsH+/YdcC5jszdV8RNrG4=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-456-xdaRNRe2MEK6H55-K-LZAg-1; Tue, 06 Jun 2023 02:25:40 -0400
X-MC-Unique: xdaRNRe2MEK6H55-K-LZAg-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-9715654ab36so404384766b.0
        for <ceph-devel@vger.kernel.org>; Mon, 05 Jun 2023 23:25:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686032739; x=1688624739;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Sc0k4E/CK5JAlKaQympAoeo/zs2zKPHL4AXiAHVoqIs=;
        b=QgOrOOAFtYh1MmAWQ5u2C2kZmZpJy4rXxge9y+Bvx5L422Ju5G/vicuXuoxgpwWt9W
         xpc2HUiHrxtiN/VtwD80EWZFIhK+o7ZG3zP4sd5qGHdJepYQLrI5ynzJ5++7kvlOzkJH
         wK5kN97HesK4XLVMYKgZL2x0/NoZyTju6KO03gOV4RNG+DqxfAUbGiwtv3qGI3jNTaHe
         9GxOu/Dyfck/MZS8ngNkbLGeNxcToes6CJIQQAWNiprJWUDm2iC/am4LTnGZvlqxGvLb
         l+pezOYPM2g8Y1Z6ICx5ZwpeysYLBkB4tiaU9ogL2O5BmMf0+aHLdn8RtYGxVGOLMTI/
         4aYw==
X-Gm-Message-State: AC+VfDwYM9qu7tuVbP66gR1UT3LXbsmoQR1OIdKk6DQW0ZCgiTjjaP7e
        RlJCMVvsgUXmK1PtnAuGT3m4CHgiNmPAbC0Lw7a0RHSMQBmwcEX/XmFVEcwzlKhKaxwRw6Q4pri
        89nlZ1d7J9vr7d1IujG48QFSNPsyoeGN7d5MvbfxvT4WUQQ==
X-Received: by 2002:a17:907:1ca0:b0:971:484:6391 with SMTP id nb32-20020a1709071ca000b0097104846391mr1268131ejc.20.1686032739206;
        Mon, 05 Jun 2023 23:25:39 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5bcUww5CjxKBOHeKYx+UiDIqE3KE+1RdnqVNWFtaa9/EpUVQSaxuSMa4PKtX8Y0aBctmKC8JreWqjoJnMy+8E=
X-Received: by 2002:a17:907:1ca0:b0:971:484:6391 with SMTP id
 nb32-20020a1709071ca000b0097104846391mr1268115ejc.20.1686032738905; Mon, 05
 Jun 2023 23:25:38 -0700 (PDT)
MIME-Version: 1.0
References: <20230417032654.32352-1-xiubli@redhat.com> <20230417032654.32352-70-xiubli@redhat.com>
In-Reply-To: <20230417032654.32352-70-xiubli@redhat.com>
From:   Milind Changire <mchangir@redhat.com>
Date:   Tue, 6 Jun 2023 11:55:03 +0530
Message-ID: <CAED=hWACph6FJwKfE-qBr9hL5NGmr9iSoKSHPsOjVxWE=4+6GQ@mail.gmail.com>
Subject: Re: [PATCH v19 69/70] ceph: switch ceph_open() to use new fscrypt helper
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org, jlayton@kernel.org,
        vshankar@redhat.com, lhenriques@suse.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

nit:
the commit title refers to ceph_open() but the code changes are
pertaining to ceph_lookup()

Otherwise it looks good to me.

Reviewed-by: Milind Changire <mchangir@redhat.com>

On Mon, Apr 17, 2023 at 9:03=E2=80=AFAM <xiubli@redhat.com> wrote:
>
> From: Lu=C3=ADs Henriques <lhenriques@suse.de>
>
> Instead of setting the no-key dentry in ceph_lookup(), use the new
> fscrypt_prepare_lookup_partial() helper.  We still need to mark the
> directory as incomplete if the directory was just unlocked.
>
> Tested-by: Lu=C3=ADs Henriques <lhenriques@suse.de>
> Tested-by: Venky Shankar <vshankar@redhat.com>
> Signed-off-by: Lu=C3=ADs Henriques <lhenriques@suse.de>
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/dir.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
>
> diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> index fe48a5d26c1d..c28de23e12a1 100644
> --- a/fs/ceph/dir.c
> +++ b/fs/ceph/dir.c
> @@ -784,14 +784,15 @@ static struct dentry *ceph_lookup(struct inode *dir=
, struct dentry *dentry,
>                 return ERR_PTR(-ENAMETOOLONG);
>
>         if (IS_ENCRYPTED(dir)) {
> -               err =3D ceph_fscrypt_prepare_readdir(dir);
> +               bool had_key =3D fscrypt_has_encryption_key(dir);
> +
> +               err =3D fscrypt_prepare_lookup_partial(dir, dentry);
>                 if (err < 0)
>                         return ERR_PTR(err);
> -               if (!fscrypt_has_encryption_key(dir)) {
> -                       spin_lock(&dentry->d_lock);
> -                       dentry->d_flags |=3D DCACHE_NOKEY_NAME;
> -                       spin_unlock(&dentry->d_lock);
> -               }
> +
> +               /* mark directory as incomplete if it has been unlocked *=
/
> +               if (!had_key && fscrypt_has_encryption_key(dir))
> +                       ceph_dir_clear_complete(dir);
>         }
>
>         /* can we conclude ENOENT locally? */
> --
> 2.39.1
>


--=20
Milind

