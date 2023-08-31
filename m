Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 275F678E6AE
	for <lists+ceph-devel@lfdr.de>; Thu, 31 Aug 2023 08:39:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344254AbjHaGjy (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 31 Aug 2023 02:39:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237316AbjHaGjx (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 31 Aug 2023 02:39:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9926B4
        for <ceph-devel@vger.kernel.org>; Wed, 30 Aug 2023 23:39:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693463950;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/ICRe6/bsyw9M3kO5mLHAOE3Pfy5C8Br81YD3+2b+MM=;
        b=QxqZk3H5vS0mn0MpyJ4QU9974wH4UrrVOlVBi5aI6DibE3TlN3AIKAz8mqkuPt5U5rRl3o
        hB6HnPxvCzpMpfF/WyM1kLFDtKOjx2BAQnK68L1FsdCvge9YN62IvYrtHqOWDdgGbuchSx
        bOamOSsyn+gzWMtj8otsYchlOKBjll4=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-330-re_eD494P_2xR-dxEHyuVw-1; Thu, 31 Aug 2023 02:34:49 -0400
X-MC-Unique: re_eD494P_2xR-dxEHyuVw-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-99cc32f2ec5so29057766b.1
        for <ceph-devel@vger.kernel.org>; Wed, 30 Aug 2023 23:34:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693463686; x=1694068486;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/ICRe6/bsyw9M3kO5mLHAOE3Pfy5C8Br81YD3+2b+MM=;
        b=KfXQFUpseeiICBKisIifyQWjJr7R5lv0+75bxsy50BcRUIpsQvo9Qq2LISD5g/h3N4
         rK9vQDc8vz+YVx7kEJEhmD8rInYl0ZNB0+IezeuivxeoQbR4qA1Qn+GqetBrmxefoE5y
         MODachTMcNeT46mz+pii9fmlMHB05Yp26kt4Yfs1p1gN0YwOUyezHkSN1WBYWt70VO5P
         tPXbutjXblh1d8es5zQ9FYplKfvDR+BLoIgacJidUlFJ4JwnlbjNYKJqrahpM+jV2bIb
         xWlq4vZh2Rt6lfc5tp6y7IQBRyXpWlWPr6C/YlWMOOzBFXmKmFx7mEMsYoVg2KiTL3mJ
         +EWQ==
X-Gm-Message-State: AOJu0Yy2EKKrSD8ibBGiQ1NouLJX8rQpR2lxl0r0rwh+7P6MLF9t71KA
        t74w9kbCqj4op6MUHj2dQ112dJoLj9RqxXceuk/43HUCq6hz8GpXYqO4B11lqjBYky/Ee/bqtw8
        ioLOL+AzXulmkCs7GDY0Zn0zhchQHd+mHp8lrmA==
X-Received: by 2002:a17:907:778e:b0:9a1:b705:75d1 with SMTP id ky14-20020a170907778e00b009a1b70575d1mr3284846ejc.51.1693463685834;
        Wed, 30 Aug 2023 23:34:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEfDoyW2TohZqlY1NMMDuggGKhY2w5PU3Dcnw4popvN5reR2e45iGhLk0AinxDAEsvkvPQlC4y/nD6//l//rcw=
X-Received: by 2002:a17:907:778e:b0:9a1:b705:75d1 with SMTP id
 ky14-20020a170907778e00b009a1b70575d1mr3284830ejc.51.1693463685522; Wed, 30
 Aug 2023 23:34:45 -0700 (PDT)
MIME-Version: 1.0
References: <20230725044024.365152-1-xiubli@redhat.com>
In-Reply-To: <20230725044024.365152-1-xiubli@redhat.com>
From:   Milind Changire <mchangir@redhat.com>
Date:   Thu, 31 Aug 2023 12:04:09 +0530
Message-ID: <CAED=hWDj916J_djfB1eX0tJX=5ubp8WiOuVtJdfZ==Ce3yWmjQ@mail.gmail.com>
Subject: Re: [PATCH] ceph: make the members in struct ceph_mds_request_args_ext
 an union
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org, jlayton@kernel.org,
        vshankar@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Approved. Looks good to me.

Reviewed-by: Milind Changire <mchangir@redhat,com>

On Tue, Jul 25, 2023 at 10:13=E2=80=AFAM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> In ceph mainline it will allow to set the btime in the setattr request
> and just add a 'btime' member in the union 'ceph_mds_request_args' and
> then bump up the header version to 4. That means the total size of union
> 'ceph_mds_request_args' will increase sizeof(struct ceph_timespec) bytes,
> but in kclient it will increase the sizeof(setattr_ext) bytes for each
> request.
>
> Since the MDS will always depend on the header's vesion and front_len
> members to decode the 'ceph_mds_request_head' struct, at the same time
> kclient hasn't supported the 'btime' feature yet in setattr request,
> so it's safe to do this change here.
>
> This will save 48 bytes memories for each request.
>
> Fixes: 4f1ddb1ea874 ("ceph: implement updated ceph_mds_request_head struc=
ture")
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  include/linux/ceph/ceph_fs.h | 24 +++++++++++++-----------
>  1 file changed, 13 insertions(+), 11 deletions(-)
>
> diff --git a/include/linux/ceph/ceph_fs.h b/include/linux/ceph/ceph_fs.h
> index ce6064b3e28f..04f769368605 100644
> --- a/include/linux/ceph/ceph_fs.h
> +++ b/include/linux/ceph/ceph_fs.h
> @@ -462,17 +462,19 @@ union ceph_mds_request_args {
>  } __attribute__ ((packed));
>
>  union ceph_mds_request_args_ext {
> -       union ceph_mds_request_args old;
> -       struct {
> -               __le32 mode;
> -               __le32 uid;
> -               __le32 gid;
> -               struct ceph_timespec mtime;
> -               struct ceph_timespec atime;
> -               __le64 size, old_size;       /* old_size needed by trunca=
te */
> -               __le32 mask;                 /* CEPH_SETATTR_* */
> -               struct ceph_timespec btime;
> -       } __attribute__ ((packed)) setattr_ext;
> +       union {
> +               union ceph_mds_request_args old;
> +               struct {
> +                       __le32 mode;
> +                       __le32 uid;
> +                       __le32 gid;
> +                       struct ceph_timespec mtime;
> +                       struct ceph_timespec atime;
> +                       __le64 size, old_size;       /* old_size needed b=
y truncate */
> +                       __le32 mask;                 /* CEPH_SETATTR_* */
> +                       struct ceph_timespec btime;
> +               } __attribute__ ((packed)) setattr_ext;
> +       };
>  };
>
>  #define CEPH_MDS_FLAG_REPLAY           1 /* this is a replayed op */
> --
> 2.40.1
>


--=20
Milind

