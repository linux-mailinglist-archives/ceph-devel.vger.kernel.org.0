Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 408B04134F0
	for <lists+ceph-devel@lfdr.de>; Tue, 21 Sep 2021 16:02:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233174AbhIUOD2 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 21 Sep 2021 10:03:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35339 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232981AbhIUOD2 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 21 Sep 2021 10:03:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632232919;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Xa4XGAlHFx72q5qe9nj4uloeA8ZOM0GW0Hc0rQLgfYI=;
        b=ct8wBewUc2vaU0cnUgSjJXRTNYDUoQCeRX5krV1duSvCo/5v1yvRgpZdF/r7QCPclZZR6G
        e0UHgrMzPhr8YAhz/uR8TPbuxXLi2RXE/s8MuFitiEQ5Inf4vvyQAFYSRo4VLEWseqbK9x
        ChAuqw/C2vPqes4uQAXHOyleYbblMfA=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-473-VFnTZydeM0GdPAnBX2p8pA-1; Tue, 21 Sep 2021 10:01:58 -0400
X-MC-Unique: VFnTZydeM0GdPAnBX2p8pA-1
Received: by mail-io1-f72.google.com with SMTP id n8-20020a6b7708000000b005bd491bdb6aso50568634iom.5
        for <ceph-devel@vger.kernel.org>; Tue, 21 Sep 2021 07:01:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Xa4XGAlHFx72q5qe9nj4uloeA8ZOM0GW0Hc0rQLgfYI=;
        b=GwsgA2Xu1qNDDTUyyQ/I+iSTH+Mtndmwnw3HsstV4BdC22DKkf2fLrxxuWuzlJDn99
         K/1IWSHY045z+5TVphrvpfQs67m2ykmB3a+73eyL6ZjJL5ENKUF2bFfNgUceYSFsy8EZ
         7+wdbWMZWxtIXzgkwC8e1itaLmjvDZ23fVnz3iqhf1AWuJ4KfeQwkyNdLPatTgyGMqJ8
         LZbCAkLoohhuQ5iqQwT9fUZpzFnJaD9Zm7qFflxN1CEdauQ79FrpT8eFB2durf3qhxq+
         C3jwM+hl17m4NgY4YuAM+CcW1TgBkRE+yunyK35+RNTC8/i4TDFvTSSZFO2cRvz923nV
         EXSQ==
X-Gm-Message-State: AOAM532p8z6c9m0qjHkNxUQUGb/BEuFtIw+dCDIu362y1DpYrSlDCOQ8
        lj6Q8SBNZZJUTShGnLPx2LSw+WOWf8ZkaZynBHOnPz9Ok+PAknHttjlJN9dX+pCTPI/ErczCcJI
        6k24tpQebA6CNE5ISDtFMvPai62KMZJRGZbtHAA==
X-Received: by 2002:a05:6e02:20c3:: with SMTP id 3mr16720207ilq.269.1632232917646;
        Tue, 21 Sep 2021 07:01:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzH0L1ahcKLJ3y7G8y7iI1BcxlFEuW+A+5jy1NyTuzpmYyK03BDUgeCf9ggeUcrsQJKD0sOVltv5QxbfCmKfh4=
X-Received: by 2002:a05:6e02:20c3:: with SMTP id 3mr16720190ilq.269.1632232917439;
 Tue, 21 Sep 2021 07:01:57 -0700 (PDT)
MIME-Version: 1.0
References: <20210825055035.306043-1-vshankar@redhat.com> <20210825055035.306043-3-vshankar@redhat.com>
In-Reply-To: <20210825055035.306043-3-vshankar@redhat.com>
From:   Patrick Donnelly <pdonnell@redhat.com>
Date:   Tue, 21 Sep 2021 10:01:31 -0400
Message-ID: <CA+2bHPYMELh_d7UnDUOaeEjHiO-1TdeRMGTWxhYKAozOjrU1SA@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] ceph: add debugfs entries for mount syntax support
To:     Venky Shankar <vshankar@redhat.com>
Cc:     Jeff Layton <jlayton@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Aug 25, 2021 at 1:51 AM Venky Shankar <vshankar@redhat.com> wrote:
>
> Signed-off-by: Venky Shankar <vshankar@redhat.com>
> ---
>  fs/ceph/debugfs.c | 36 ++++++++++++++++++++++++++++++++++++
>  fs/ceph/super.c   |  3 +++
>  fs/ceph/super.h   |  2 ++
>  3 files changed, 41 insertions(+)
>
> diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
> index 66989c880adb..f9ff70704423 100644
> --- a/fs/ceph/debugfs.c
> +++ b/fs/ceph/debugfs.c
> @@ -22,6 +22,14 @@
>  #include "mds_client.h"
>  #include "metric.h"
>
> +#define CLIENT_FEATURES_DIR_NAME   "client_features"
> +#define MOUNT_DEVICE_V1_SUPPORT_FILE_NAME "v1_mount_syntax"
> +#define MOUNT_DEVICE_V2_SUPPORT_FILE_NAME "v2_mount_syntax"
> +
> +static struct dentry *ceph_client_features_dir;
> +static struct dentry *ceph_mount_device_v1_support;
> +static struct dentry *ceph_mount_device_v2_support;
> +
>  static int mdsmap_show(struct seq_file *s, void *p)
>  {
>         int i;
> @@ -416,6 +424,26 @@ void ceph_fs_debugfs_init(struct ceph_fs_client *fsc)
>                                                   &status_fops);
>  }
>
> +void ceph_fs_debugfs_client_features_init(void)
> +{
> +       ceph_client_features_dir = debugfs_create_dir(CLIENT_FEATURES_DIR_NAME,
> +                                                     ceph_debugfs_dir);
> +       ceph_mount_device_v1_support = debugfs_create_file(MOUNT_DEVICE_V1_SUPPORT_FILE_NAME,
> +                                                          0400,
> +                                                          ceph_client_features_dir,
> +                                                          NULL, NULL);
> +       ceph_mount_device_v2_support = debugfs_create_file(MOUNT_DEVICE_V2_SUPPORT_FILE_NAME,
> +                                                          0400,
> +                                                          ceph_client_features_dir,
> +                                                          NULL, NULL);
> +}

Makes sense to me. I can see having separate files for each syntax
type is expedient. If Jeff is cool with this then so am I.

-- 
Patrick Donnelly, Ph.D.
He / Him / His
Principal Software Engineer
Red Hat Sunnyvale, CA
GPG: 19F28A586F808C2402351B93C3301A3E258DD79D

