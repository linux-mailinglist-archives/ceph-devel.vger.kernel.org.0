Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6EBF72241C
	for <lists+ceph-devel@lfdr.de>; Mon,  5 Jun 2023 13:04:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231642AbjFELEz (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 5 Jun 2023 07:04:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231849AbjFELEs (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 5 Jun 2023 07:04:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC73AFD
        for <ceph-devel@vger.kernel.org>; Mon,  5 Jun 2023 04:03:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685963038;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QFMPWdHxcFyANacOUVvpSmI9+s3KvKrZDwu68VOBYDA=;
        b=U0hD6vSf8tnRQo5xZzQKTQHQSCMm+pzM2Ki86df+tBAVcdxI51LtE28VwTfpi8lpRN8eUn
        vM9zvF4sPeNcgqZXqOse0ikq2/V1zoH8dNso6SSDkdAMyACyCW2Ftb8TYVkR7qS/+vW6yi
        COe2akgk1GxyKBsFn0cjBfkNxmW7G0o=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-573-PI90pI9_OTeHjdFVbWs3UQ-1; Mon, 05 Jun 2023 07:03:57 -0400
X-MC-Unique: PI90pI9_OTeHjdFVbWs3UQ-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-95847b4b4e7so378080766b.3
        for <ceph-devel@vger.kernel.org>; Mon, 05 Jun 2023 04:03:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685963036; x=1688555036;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QFMPWdHxcFyANacOUVvpSmI9+s3KvKrZDwu68VOBYDA=;
        b=U/XONwKbGk9z8DkcrwNKm46WVezFlots1V4ePwY8gELFXrmlJlpPp2qErIMwu0utE2
         8kQfkjJtWNd8WOAJuv5yfx+rOw/M46n/hC0LnK9UbROUqPFo6Lc4DJ8ynFDvAqUQ7cCt
         SCN43C6SU/l+SQyziEO38rlsFLG7m8wRErnvKTe4/Qvdf22wxfXFWeNToAWRXtsNsAZD
         WRL8fJFdT5saN5/waChAdJUXLNAM3sjmnRt07Y5Gizd8rnLrLUurvSIMllhZDfWo6tjx
         jrN0jyrx4Y2C53Isqj+dQotcVXRtTlOFYfSQDf/EubSGLqRbTug4oCBEsoSK3WX0U0x+
         hTbQ==
X-Gm-Message-State: AC+VfDwWQxkpeHbh/x2V4QFC+eUsxuB8V3oLt//rhQ0Qxjk8rN3GtCF1
        S9B8rn70jwcgv4y6yK9JTUF3lF+0RqB/d/wpyCXTC+Qe/lbNn38hQqgeRSUSmbjfC23lhbMfuBA
        mnblAMZWixJrWWOSHb9VdLdi3RtIQ99vkFUxxWw==
X-Received: by 2002:a17:907:971b:b0:962:9ffa:be02 with SMTP id jg27-20020a170907971b00b009629ffabe02mr6705422ejc.36.1685963036684;
        Mon, 05 Jun 2023 04:03:56 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6gXIcJ9b4Xdt0/+AvpnZjUKN8Fh8r7nPJTRmbHC/s0eMVDUGR1Em3E9otairkX7JDmr6RWu/CeHMtPI/6z6LE=
X-Received: by 2002:a17:907:971b:b0:962:9ffa:be02 with SMTP id
 jg27-20020a170907971b00b009629ffabe02mr6705415ejc.36.1685963036454; Mon, 05
 Jun 2023 04:03:56 -0700 (PDT)
MIME-Version: 1.0
References: <TYCP286MB20661F87B0C796738BDC5FBEC0709@TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM>
 <TYCP286MB2066C89FCBD9FB30AFDF2D70C0709@TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM>
 <ce388c9d-97f1-57fb-4ed2-745596e1bd5f@redhat.com> <ed6d4ae8-98af-4cca-9c2d-4d172b622988@redhat.com>
In-Reply-To: <ed6d4ae8-98af-4cca-9c2d-4d172b622988@redhat.com>
From:   Milind Changire <mchangir@redhat.com>
Date:   Mon, 5 Jun 2023 16:33:20 +0530
Message-ID: <CAED=hWCTdXpFryceK4CSWMT0CShveME8LsrHENnyXtajeVnb6Q@mail.gmail.com>
Subject: Re: [PATCH 1/3] ceph: refactor mds_namespace comparing
To:     Xiubo Li <xiubli@redhat.com>
Cc:     Hu Weiwen <huww98@outlook.com>, ceph-devel@vger.kernel.org,
        Ilya Dryomov <idryomov@gmail.com>,
        Venky Shankar <vshankar@redhat.com>,
        Hu Weiwen <sehuww@mail.scut.edu.cn>
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


On Tue, May 9, 2023 at 7:14=E2=80=AFAM Xiubo Li <xiubli@redhat.com> wrote:
>
>
> On 5/9/23 09:04, Xiubo Li wrote:
> >
> > On 5/8/23 01:55, Hu Weiwen wrote:
> >> From: Hu Weiwen <sehuww@mail.scut.edu.cn>
> >>
> >> Same logic, slightly less code.  Make the following changes easier.
> >>
> >> Signed-off-by: Hu Weiwen <sehuww@mail.scut.edu.cn>
> >> ---
> >>   fs/ceph/super.c | 34 ++++++++++++++--------------------
> >>   1 file changed, 14 insertions(+), 20 deletions(-)
> >>
> >> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> >> index 3fc48b43cab0..4e1f4031e888 100644
> >> --- a/fs/ceph/super.c
> >> +++ b/fs/ceph/super.c
> >> @@ -235,18 +235,10 @@ static void canonicalize_path(char *path)
> >>       path[j] =3D '\0';
> >>   }
> >>   -/*
> >> - * Check if the mds namespace in ceph_mount_options matches
> >> - * the passed in namespace string. First time match (when
> >> - * ->mds_namespace is NULL) is treated specially, since
> >> - * ->mds_namespace needs to be initialized by the caller.
> >> - */
> >> -static int namespace_equals(struct ceph_mount_options *fsopt,
> >> -                const char *namespace, size_t len)
> >> +/* check if s1 (null terminated) equals to s2 (with length len2) */
> >> +static int strstrn_equals(const char *s1, const char *s2, size_t len2=
)
> >>   {
> >> -    return !(fsopt->mds_namespace &&
> >> -         (strlen(fsopt->mds_namespace) !=3D len ||
> >> -          strncmp(fsopt->mds_namespace, namespace, len)));
> >> +    return !strncmp(s1, s2, len2) && strlen(s1) =3D=3D len2;
> >>   }
> >
> > Could this helper be defined as inline explicitly ?
> >
> Please ignore this, I misreaded and it's not in the header file.
>
>
> >>     static int ceph_parse_old_source(const char *dev_name, const char
> >> *dev_name_end,
> >> @@ -297,12 +289,13 @@ static int ceph_parse_new_source(const char
> >> *dev_name, const char *dev_name_end,
> >>       ++fs_name_start; /* start of file system name */
> >>       len =3D dev_name_end - fs_name_start;
> >>   -    if (!namespace_equals(fsopt, fs_name_start, len))
> >> +    if (!fsopt->mds_namespace) {
> >> +        fsopt->mds_namespace =3D kstrndup(fs_name_start, len,
> >> GFP_KERNEL);
> >> +        if (!fsopt->mds_namespace)
> >> +            return -ENOMEM;
> >> +    } else if (!strstrn_equals(fsopt->mds_namespace, fs_name_start,
> >> len)) {
> >>           return invalfc(fc, "Mismatching mds_namespace");
> >> -    kfree(fsopt->mds_namespace);
> >> -    fsopt->mds_namespace =3D kstrndup(fs_name_start, len, GFP_KERNEL)=
;
> >> -    if (!fsopt->mds_namespace)
> >> -        return -ENOMEM;
> >> +    }
> >>       dout("file system (mds namespace) '%s'\n", fsopt->mds_namespace)=
;
> >>         fsopt->new_dev_syntax =3D true;
> >> @@ -417,11 +410,12 @@ static int ceph_parse_mount_param(struct
> >> fs_context *fc,
> >>           param->string =3D NULL;
> >>           break;
> >>       case Opt_mds_namespace:
> >> -        if (!namespace_equals(fsopt, param->string,
> >> strlen(param->string)))
> >> +        if (!fsopt->mds_namespace) {
> >> +            fsopt->mds_namespace =3D param->string;
> >> +            param->string =3D NULL;
> >> +        } else if (strcmp(fsopt->mds_namespace, param->string)) {
> >>               return invalfc(fc, "Mismatching mds_namespace");
> >> -        kfree(fsopt->mds_namespace);
> >> -        fsopt->mds_namespace =3D param->string;
> >> -        param->string =3D NULL;
> >> +        }
> >>           break;
> >>       case Opt_recover_session:
> >>           mode =3D result.uint_32;
>


--=20
Milind

