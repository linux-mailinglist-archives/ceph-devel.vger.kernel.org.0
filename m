Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 851C513247D
	for <lists+ceph-devel@lfdr.de>; Tue,  7 Jan 2020 12:08:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727747AbgAGLI0 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 7 Jan 2020 06:08:26 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:44368 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727273AbgAGLI0 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 7 Jan 2020 06:08:26 -0500
Received: by mail-io1-f68.google.com with SMTP id b10so52144840iof.11
        for <ceph-devel@vger.kernel.org>; Tue, 07 Jan 2020 03:08:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3pYz5pU9KdYtdbhoAWeaJMRsOc4yqXlhFISjToZ5/VA=;
        b=LjAbletIaXfSdCH/a+Pi1zUiTlMdtAc+ZwzjnIxg+6gG/bSnSoVhz8RJeT4ZktIo5P
         SiraY8Q+yyFK0K6ttCZuePEMvIJsP6gWR1L3PCCgVshwO+ayqNBEjQNL77GcF18vrFco
         MLhvtMv8275/wKjgCE4Wj3d22IFewo7LbK0oz5t+hYhhPdhrJ+pIA4yhJJA50k3uIRrL
         Be49GK5PObmjCQQyGrwNmLL4s8OEJ38fPM4xfMjQgE0hbehY6X+BtSk1GUmvCfeFgAus
         4Dh5mEdFcqSnblV9VNHdv7X89XNCP/FX5dKJcoPQWDyP53AssMjZEQKSBusB62ihgDM6
         Lafw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3pYz5pU9KdYtdbhoAWeaJMRsOc4yqXlhFISjToZ5/VA=;
        b=B9qe1jXvW10X+HuzeP6JJbydHSaWXZmDQU5rTUSb7gHJp1Rg9tMbe8USLKC6uIaW2x
         ck+G5pQ2sGOz+C+OVjW4QJmt+PMmS4u380Nm66mWFKyKX3hLz2O9nVSvD5TlA2eB6L09
         707FSgMGnZAJExaPv8BzS6pI80Z9qamhx9CNSjV20JMSE8/AG2/JH5pTPobNYsE4VKYp
         oRX74v8cvdWUPi5qzAxKRHTUw6K5gBZDg56L0xtceHFy2wS63797bjD/VQ8L0dzd9dPM
         poYexoSdirUEZINsMhq2UThedd1LGW6Uiylge1JHjPYlh2E1/Xem/gpKFEjCWXSbPBwe
         oSIw==
X-Gm-Message-State: APjAAAW2x4n7LbWGmcPQXOr/Kat3RoRVrHDZCD9Rf5LhJfuBJ2g2+iXH
        lvUEnH2n/RehvfVHw7FzX1Tn/91gXPAjyHnOrMQ=
X-Google-Smtp-Source: APXvYqz5HZDjyP7pQjDJC9/AQb2CmCkpeuzgP6+ymMslbxgaWGa7t1huiig/mB0GGKh8MTWP/QtP4n6UHmfHJS9df7s=
X-Received: by 2002:a6b:d20c:: with SMTP id q12mr70080706iob.143.1578395305569;
 Tue, 07 Jan 2020 03:08:25 -0800 (PST)
MIME-Version: 1.0
References: <20191224040514.26144-1-xiubli@redhat.com> <20191224040514.26144-5-xiubli@redhat.com>
In-Reply-To: <20191224040514.26144-5-xiubli@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 7 Jan 2020 12:13:25 +0100
Message-ID: <CAOi1vP-XGL1irAer-v8W0Jv9-aapARn-zoDdrxuutPAERtqPVw@mail.gmail.com>
Subject: Re: [PATCH 4/4] ceph: add enable/disable sending metrics to MDS
 debugfs support
To:     Xiubo Li <xiubli@redhat.com>
Cc:     Jeff Layton <jlayton@kernel.org>, Sage Weil <sage@redhat.com>,
        "Yan, Zheng" <zyan@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Dec 24, 2019 at 5:05 AM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> Disabled as default, if it's enabled the kclient will send metrics
> every second.
>
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/debugfs.c    | 44 ++++++++++++++++++++++++++++++--
>  fs/ceph/mds_client.c | 60 +++++++++++++++++++++++++++++++-------------
>  fs/ceph/mds_client.h |  3 +++
>  fs/ceph/super.h      |  1 +
>  4 files changed, 89 insertions(+), 19 deletions(-)
>
> diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
> index c132fdb40d53..a26e559473fd 100644
> --- a/fs/ceph/debugfs.c
> +++ b/fs/ceph/debugfs.c
> @@ -124,6 +124,40 @@ static int mdsc_show(struct seq_file *s, void *p)
>         return 0;
>  }
>
> +/*
> + * metrics debugfs
> + */
> +static int sending_metrics_set(void *data, u64 val)
> +{
> +       struct ceph_fs_client *fsc = (struct ceph_fs_client *)data;
> +       struct ceph_mds_client *mdsc = fsc->mdsc;
> +
> +       if (val > 1) {
> +               pr_err("Invalid sending metrics set value %llu\n", val);
> +               return -EINVAL;
> +       }
> +
> +       mutex_lock(&mdsc->mutex);
> +       mdsc->sending_metrics = (unsigned int)val;
> +       mutex_unlock(&mdsc->mutex);
> +
> +       return 0;
> +}
> +
> +static int sending_metrics_get(void *data, u64 *val)
> +{
> +       struct ceph_fs_client *fsc = (struct ceph_fs_client *)data;
> +       struct ceph_mds_client *mdsc = fsc->mdsc;
> +
> +       mutex_lock(&mdsc->mutex);
> +       *val = (u64)mdsc->sending_metrics;
> +       mutex_unlock(&mdsc->mutex);
> +
> +       return 0;
> +}
> +DEFINE_DEBUGFS_ATTRIBUTE(sending_metrics_fops, sending_metrics_get,
> +                        sending_metrics_set, "%llu\n");
> +
>  static int metric_show(struct seq_file *s, void *p)
>  {
>         struct ceph_fs_client *fsc = s->private;
> @@ -279,11 +313,9 @@ static int congestion_kb_get(void *data, u64 *val)
>         *val = (u64)fsc->mount_options->congestion_kb;
>         return 0;
>  }
> -
>  DEFINE_SIMPLE_ATTRIBUTE(congestion_kb_fops, congestion_kb_get,
>                         congestion_kb_set, "%llu\n");
>
> -
>  void ceph_fs_debugfs_cleanup(struct ceph_fs_client *fsc)
>  {
>         dout("ceph_fs_debugfs_cleanup\n");
> @@ -293,6 +325,7 @@ void ceph_fs_debugfs_cleanup(struct ceph_fs_client *fsc)
>         debugfs_remove(fsc->debugfs_mds_sessions);
>         debugfs_remove(fsc->debugfs_caps);
>         debugfs_remove(fsc->debugfs_metric);
> +       debugfs_remove(fsc->debugfs_sending_metrics);
>         debugfs_remove(fsc->debugfs_mdsc);
>  }
>
> @@ -333,6 +366,13 @@ void ceph_fs_debugfs_init(struct ceph_fs_client *fsc)
>                                                 fsc,
>                                                 &mdsc_show_fops);
>
> +       fsc->debugfs_sending_metrics =
> +                       debugfs_create_file_unsafe("sending_metrics",
> +                                                  0600,
> +                                                  fsc->client->debugfs_dir,
> +                                                  fsc,
> +                                                  &sending_metrics_fops);

Hi Xiubo,

Same question as to Chen.  Why are you using the unsafe variant
with DEFINE_DEBUGFS_ATTRIBUTE instead of just mirroring the existing
writeback_congestion_kb?  Have you verified that it is safe?

I was a little confused by this series as a whole too.  Patch 3 says
that these metrics will be sent every 5 seconds, which matches the caps
tick interval.  This patch changes that to 1 second and makes sending
metrics optional.  Perhaps merge patches 3 and 4 into a single patch
with a better changelog?

Do we really need to send metrics more often than we potentially renew
caps?

Thanks,

                Ilya
