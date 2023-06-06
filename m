Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0824B72377B
	for <lists+ceph-devel@lfdr.de>; Tue,  6 Jun 2023 08:20:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234933AbjFFGUl (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 6 Jun 2023 02:20:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235080AbjFFGUR (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 6 Jun 2023 02:20:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9C6F10C7
        for <ceph-devel@vger.kernel.org>; Mon,  5 Jun 2023 23:19:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686032357;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OsX79rQgdRGDgfnq1AsPUarTvN+cIy7gbKpn6Yemtuw=;
        b=HfsRW6b6i7msv9rsDaqCUn4TcqWQ9wpw2esLAolpxStRmIdY6aDiZG777uN+Z6gX+opk9x
        nfMkbALldDRI/5aR8nvMBL52ryEbLNFsg73Sks0oty3Jue5g/r3jrpkGc7+QSCt+G1qHSl
        Tm2AaC1fWBW0haQ7GoD+VipgoHqITss=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-38-9-PEDfNlMM-PRS6VKMwOWA-1; Tue, 06 Jun 2023 02:19:16 -0400
X-MC-Unique: 9-PEDfNlMM-PRS6VKMwOWA-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-94a35b0d4ceso403253966b.3
        for <ceph-devel@vger.kernel.org>; Mon, 05 Jun 2023 23:19:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686032355; x=1688624355;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OsX79rQgdRGDgfnq1AsPUarTvN+cIy7gbKpn6Yemtuw=;
        b=a9zJC43RMVRaeANpID2VBW++IDYV7QqaZF3+CtzIMGF11s+3i3bVdFjrhIGGWu49g9
         8aKWbwFGd9pjc8ZY6KpYYmGSYY0aDE9afNJBDpqj9zD40Q1a0Ant8OEx71LIWWOlqlTB
         vr/cep7GsBOEIxCN6Vt5nNRxNrcncTl7tAqLE2dKkjLY4Y1RqarnuP22bJVjkeqU7hl+
         IQocPDaI8Z24MATPQvptQxUwVAWnZVShfKwLFZZ6Tp8MTYvsdfskp9TBbSI9qdgwd1P2
         6cGfeYkszwp8uQytOJFSE4ByIY3Wg3+sCqtVLINlcU2vGV/YRSN/fwQvp93qDG+183GL
         ///Q==
X-Gm-Message-State: AC+VfDwBzovqVx+l3wJtrLLGeOZYcTHxrd3oAG2iWqqUJu48IUU6TiGr
        OCKQAsqTiAaA8XIrx8kVPNJpPw25vADMb+LLQEIZ/ERCKS2l/4/vY+ok3anUJDXu/RcDoMe2Y9B
        SveEzzNf1nktvlvmm81smH6QkKYGtr7KH3Zm9Zg==
X-Received: by 2002:a17:907:2d28:b0:973:e4c2:2bcd with SMTP id gs40-20020a1709072d2800b00973e4c22bcdmr1236242ejc.18.1686032355283;
        Mon, 05 Jun 2023 23:19:15 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6FNnCUbOu8jYFMwKFOBys6foub9aUa9FnUSy0E/N/hsLp+1r34+Qc1aUwRmqV+0PxIZQRg8md2sbc29LkN0u4=
X-Received: by 2002:a17:907:2d28:b0:973:e4c2:2bcd with SMTP id
 gs40-20020a1709072d2800b00973e4c22bcdmr1236227ejc.18.1686032354983; Mon, 05
 Jun 2023 23:19:14 -0700 (PDT)
MIME-Version: 1.0
References: <20230417032654.32352-1-xiubli@redhat.com> <20230417032654.32352-71-xiubli@redhat.com>
In-Reply-To: <20230417032654.32352-71-xiubli@redhat.com>
From:   Milind Changire <mchangir@redhat.com>
Date:   Tue, 6 Jun 2023 11:48:39 +0530
Message-ID: <CAED=hWBb5sOwkL8MzcSQQt4=5AKLtfO+O3eCPFTCAiXFKB+myA@mail.gmail.com>
Subject: Re: [PATCH v19 70/70] ceph: switch ceph_open_atomic() to use the new
 fscrypt helper
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

Looks good to me.

Reviewed-by: Milind Changire <mchangir@redhat.com>

On Mon, Apr 17, 2023 at 9:03=E2=80=AFAM <xiubli@redhat.com> wrote:
>
> From: Lu=C3=ADs Henriques <lhenriques@suse.de>
>
> Switch ceph_atomic_open() to use new fscrypt helper function
> fscrypt_prepare_lookup_partial().  This fixes a bug in the atomic open
> operation where a dentry is incorrectly set with DCACHE_NOKEY_NAME when
> 'dir' has been evicted but the key is still available (for example, where
> there's a drop_caches).
>
> Tested-by: Lu=C3=ADs Henriques <lhenriques@suse.de>
> Tested-by: Venky Shankar <vshankar@redhat.com>
> Signed-off-by: Lu=C3=ADs Henriques <lhenriques@suse.de>
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/file.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
>
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 317087ea017e..9e74ed673f93 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -791,11 +791,9 @@ int ceph_atomic_open(struct inode *dir, struct dentr=
y *dentry,
>         ihold(dir);
>         if (IS_ENCRYPTED(dir)) {
>                 set_bit(CEPH_MDS_R_FSCRYPT_FILE, &req->r_req_flags);
> -               if (!fscrypt_has_encryption_key(dir)) {
> -                       spin_lock(&dentry->d_lock);
> -                       dentry->d_flags |=3D DCACHE_NOKEY_NAME;
> -                       spin_unlock(&dentry->d_lock);
> -               }
> +               err =3D fscrypt_prepare_lookup_partial(dir, dentry);
> +               if (err < 0)
> +                       goto out_req;
>         }
>
>         if (flags & O_CREAT) {
> --
> 2.39.1
>


--=20
Milind

