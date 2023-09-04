Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC0777914C5
	for <lists+ceph-devel@lfdr.de>; Mon,  4 Sep 2023 11:32:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243230AbjIDJcE (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 4 Sep 2023 05:32:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234330AbjIDJcD (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 4 Sep 2023 05:32:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 899C2BF
        for <ceph-devel@vger.kernel.org>; Mon,  4 Sep 2023 02:31:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693819872;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K9l0wQqfFwDeF7ukgyScKmgqMBi0X3TKAJGfHAct9xQ=;
        b=hedWmTAbyVMgdgR+OP6dkKUsFbe4XvXnwBL6RJYvmR7/OsOwVRNlQc5GnMOF2qP2LQYh/D
        5i0kAxIRjWUQEoh+xG8KyonyuUOv5n/86h+v4oCwPsYmJRWfYOflyfUfBmyBcsu66aqFHR
        fxP/Xi73vcFD9EyJ3IEWEtSSZH8iiZ8=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-329-6wLC-flJPOKET6WknEIKOQ-1; Mon, 04 Sep 2023 05:31:11 -0400
X-MC-Unique: 6wLC-flJPOKET6WknEIKOQ-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-993831c639aso89648866b.2
        for <ceph-devel@vger.kernel.org>; Mon, 04 Sep 2023 02:31:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693819870; x=1694424670;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K9l0wQqfFwDeF7ukgyScKmgqMBi0X3TKAJGfHAct9xQ=;
        b=hogcGKl0zwNrQJ/yrzKpTZOMv10pSpL+8QPv4OYFRoJM7b80At7hZFFy31YpMB3sWE
         h9SN7JWJdjdPPC8jlA5puxn59j2fbQyCg9Yq4Uml4fNFgOFLV0q8uWLZJUAyJOLWlzox
         9eu4f6e+32KSyDr6XIRMxehmGRytMEJdcA0WiqyKlZHAWyJaOkOSpZxYh8nBLWMxmjuX
         H2IKcfuSdfeye2TsHYiKHRpOmOnBp/g3MLs40CmgUXlSca7X+0x0ylNXB6266pQG/IOT
         8JbbFJNSKp5QURCcnPdJSRX4P32DsNsVoD/ejZXT12ISvjnjtelqH4fLNGnFdatwGU6y
         Nogw==
X-Gm-Message-State: AOJu0YwpLz0AMWe/fdjN+XXKo02wCMgYqunEV8SKLZedd6JWDHO9AON9
        ERoxKZ2aVmkSFFrRJN9C3KiB+PCR+YaqbO2na2RD0+V4Rw+Wuwx2zVCzYhZxeCiqq492XBa57Wr
        pm9Rp0yOSbLmNT2S1rhBU+knHEtnQAZEzO9sPdA==
X-Received: by 2002:a17:907:77d1:b0:9a2:1e14:86bd with SMTP id kz17-20020a17090777d100b009a21e1486bdmr6811010ejc.65.1693819870425;
        Mon, 04 Sep 2023 02:31:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEgW6CLiRpm7u1bqDAuoe2bQvq8GaEUacnB2NxVXR/OOeK9DRP2TRpk0Reazvm/Mp0ETdA+YQgSG7xnb36fhRw=
X-Received: by 2002:a17:907:77d1:b0:9a2:1e14:86bd with SMTP id
 kz17-20020a17090777d100b009a21e1486bdmr6810999ejc.65.1693819870210; Mon, 04
 Sep 2023 02:31:10 -0700 (PDT)
MIME-Version: 1.0
References: <20230619071438.7000-1-xiubli@redhat.com> <20230619071438.7000-6-xiubli@redhat.com>
In-Reply-To: <20230619071438.7000-6-xiubli@redhat.com>
From:   Milind Changire <mchangir@redhat.com>
Date:   Mon, 4 Sep 2023 15:00:33 +0530
Message-ID: <CAED=hWDwcQ_vv=_5WOT2_T66eU9Yk49PouYywkoAQe5064L4Tw@mail.gmail.com>
Subject: Re: [PATCH v4 5/6] ceph: add ceph_inode_to_client() helper support
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org, jlayton@kernel.org,
        vshankar@redhat.com, Patrick Donnelly <pdonnell@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Looks good to me.

Tested-by: Milind Changire <mchangir@redhat.com>
Tested-by: Venky Shankar <vshankar@redhat.com>
Reviewed-by: Milind Changire <mchangir@redhat.com>
Reviewed-by: Venky Shankar <vshankar@redhat.com>

On Mon, Jun 19, 2023 at 12:47=E2=80=AFPM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> This will covert the inode to ceph_client.
>
> URL: https://tracker.ceph.com/issues/61590
> Cc: Patrick Donnelly <pdonnell@redhat.com>
> Reviewed-by: Patrick Donnelly <pdonnell@redhat.com>
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/snap.c  | 8 +++++---
>  fs/ceph/super.h | 6 ++++++
>  2 files changed, 11 insertions(+), 3 deletions(-)
>
> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
> index 09939ec0d1ee..9dde4b5f513d 100644
> --- a/fs/ceph/snap.c
> +++ b/fs/ceph/snap.c
> @@ -329,7 +329,8 @@ static int cmpu64_rev(const void *a, const void *b)
>  /*
>   * build the snap context for a given realm.
>   */
> -static int build_snap_context(struct ceph_snap_realm *realm,
> +static int build_snap_context(struct ceph_mds_client *mdsc,
> +                             struct ceph_snap_realm *realm,
>                               struct list_head *realm_queue,
>                               struct list_head *dirty_realms)
>  {
> @@ -425,7 +426,8 @@ static int build_snap_context(struct ceph_snap_realm =
*realm,
>  /*
>   * rebuild snap context for the given realm and all of its children.
>   */
> -static void rebuild_snap_realms(struct ceph_snap_realm *realm,
> +static void rebuild_snap_realms(struct ceph_mds_client *mdsc,
> +                               struct ceph_snap_realm *realm,
>                                 struct list_head *dirty_realms)
>  {
>         LIST_HEAD(realm_queue);
> @@ -858,7 +860,7 @@ int ceph_update_snap_trace(struct ceph_mds_client *md=
sc,
>
>         /* rebuild_snapcs when we reach the _end_ (root) of the trace */
>         if (realm_to_rebuild && p >=3D e)
> -               rebuild_snap_realms(realm_to_rebuild, &dirty_realms);
> +               rebuild_snap_realms(mdsc, realm_to_rebuild, &dirty_realms=
);
>
>         if (!first_realm)
>                 first_realm =3D realm;
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index 9655ea46e6ca..4e78de1be23e 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -507,6 +507,12 @@ ceph_sb_to_mdsc(const struct super_block *sb)
>         return (struct ceph_mds_client *)ceph_sb_to_fs_client(sb)->mdsc;
>  }
>
> +static inline struct ceph_client *
> +ceph_inode_to_client(const struct inode *inode)
> +{
> +       return (struct ceph_client *)ceph_inode_to_fs_client(inode)->clie=
nt;
> +}
> +
>  static inline struct ceph_vino
>  ceph_vino(const struct inode *inode)
>  {
> --
> 2.40.1
>


--=20
Milind

