Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8342613DE37
	for <lists+ceph-devel@lfdr.de>; Thu, 16 Jan 2020 16:03:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbgAPPC7 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 16 Jan 2020 10:02:59 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:40754 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726189AbgAPPC7 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 16 Jan 2020 10:02:59 -0500
Received: by mail-io1-f66.google.com with SMTP id x1so22060442iop.7
        for <ceph-devel@vger.kernel.org>; Thu, 16 Jan 2020 07:02:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YmWwJuEqLq7OcakRc6JSBKh7wCFkxIjKSGd0GK2agVQ=;
        b=VXAcwr3sDR8nP/WwezTNn0bA/4PT6Xw4Fmzk/zb7b5mT1Yru4mXL6hsW4gjOV10yzk
         ej82/R3ZNxEZqWElfAjzUBq3SPEztHta6JVZiw+q9Q9FSP8Mt4G/Q+wjWeGh7aAFEAtF
         kyYz5UyBLXUqBd1bJbeAN9i686kXrq1ZEvfihb9+JwjveFh9vUQ4W1MZDR3wSNUksKDR
         MUl+BzPVX9S8c/oSBwjkBacVJEmD/qxPmrsmm3yAZtWrn5xLPngFPO7l0gt3hoaMGPQd
         hGgStE/9o7xbQ5/tbHHBleqtEklGHs4nVtBb1jZ+tnTLUUJ1DhLXQAlPXMfkF+mE2vSb
         JFlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YmWwJuEqLq7OcakRc6JSBKh7wCFkxIjKSGd0GK2agVQ=;
        b=KdQSIAM7H4h9mKW2ff1+j+/KcXfAgvs4XfIRVA2q6t5tx7hU0XQl5YMm7YO52oEEwf
         ZN9npxCAdKRnZGGcAKx/QO6xdTm4vLUkQX8Z/E+6k1PUsr6CH/2Nry0Xd+Fx+O2KFTAq
         lSCNnx530p5Auluuc5QxCKEAXKLD02AaZlF8H34i2bd4DvhA9+JxGzDrbg4T+2pbwYoZ
         HdxwkL2S+K8QpFDqZ4IssSdTcYOvHkdDiZqwiLc96rG/Po5/81R2x8Hfc25uwTAMohGL
         dW6LzipTNh+LhSaGV5XHqRtoZNh3OS8DYZaOttzV+HIOWp9bY03K4Cau8nI8gtMbj0P5
         rAaQ==
X-Gm-Message-State: APjAAAWDu55Jl8LIqpvlcT/jbNi4uzapVHQ1QudN7gbxqCNDWLjhvYZd
        /ivBEgct5Tmu52dUp1CxRhdmloGsmSq/4XGaYqvqajrguac=
X-Google-Smtp-Source: APXvYqz2xDFhlOfUHp9A7/DlP0cUgwXGxmeXE4uuHU38J8TF9lJFHpIswI/BGIbIlGcJXBPLFSWr6yx4SbhcNuf3NJ8=
X-Received: by 2002:a02:8587:: with SMTP id d7mr28802565jai.39.1579186977954;
 Thu, 16 Jan 2020 07:02:57 -0800 (PST)
MIME-Version: 1.0
References: <20200116103830.13591-1-xiubli@redhat.com> <20200116103830.13591-8-xiubli@redhat.com>
In-Reply-To: <20200116103830.13591-8-xiubli@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Thu, 16 Jan 2020 16:02:55 +0100
Message-ID: <CAOi1vP8iASjyLoTFo2CgiA4C-8u4nYKpEpyC91wAho=2_9hBuQ@mail.gmail.com>
Subject: Re: [PATCH v4 7/8] ceph: add reset metrics support
To:     Xiubo Li <xiubli@redhat.com>
Cc:     Jeff Layton <jlayton@kernel.org>, "Yan, Zheng" <zyan@redhat.com>,
        Sage Weil <sage@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Jan 16, 2020 at 11:39 AM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> This will reset the most metric counters, except the cap and dentry
> total numbers.
>
> Sometimes we need to discard the old metrics and start to get new
> metrics.
>
> URL: https://tracker.ceph.com/issues/43215
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/debugfs.c | 57 +++++++++++++++++++++++++++++++++++++++++++++++
>  fs/ceph/super.h   |  1 +
>  2 files changed, 58 insertions(+)
>
> diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
> index bb96fb4d04c4..c24a704d4e99 100644
> --- a/fs/ceph/debugfs.c
> +++ b/fs/ceph/debugfs.c
> @@ -158,6 +158,55 @@ static int sending_metrics_get(void *data, u64 *val)
>  DEFINE_SIMPLE_ATTRIBUTE(sending_metrics_fops, sending_metrics_get,
>                         sending_metrics_set, "%llu\n");
>
> +static int reset_metrics_set(void *data, u64 val)
> +{
> +       struct ceph_fs_client *fsc = (struct ceph_fs_client *)data;
> +       struct ceph_mds_client *mdsc = fsc->mdsc;
> +       struct ceph_client_metric *metric = &mdsc->metric;
> +       int i;
> +
> +       if (val != 1) {
> +               pr_err("Invalid reset metrics set value %llu\n", val);
> +               return -EINVAL;
> +       }
> +
> +       percpu_counter_set(&metric->d_lease_hit, 0);
> +       percpu_counter_set(&metric->d_lease_mis, 0);
> +
> +       spin_lock(&metric->read_lock);
> +       memset(&metric->read_latency_sum, 0, sizeof(struct timespec64));
> +       atomic64_set(&metric->total_reads, 0),
> +       spin_unlock(&metric->read_lock);
> +
> +       spin_lock(&metric->write_lock);
> +       memset(&metric->write_latency_sum, 0, sizeof(struct timespec64));
> +       atomic64_set(&metric->total_writes, 0),
> +       spin_unlock(&metric->write_lock);
> +
> +       spin_lock(&metric->metadata_lock);
> +       memset(&metric->metadata_latency_sum, 0, sizeof(struct timespec64));
> +       atomic64_set(&metric->total_metadatas, 0),
> +       spin_unlock(&metric->metadata_lock);
> +
> +       mutex_lock(&mdsc->mutex);
> +       for (i = 0; i < mdsc->max_sessions; i++) {
> +               struct ceph_mds_session *session;
> +
> +               session = __ceph_lookup_mds_session(mdsc, i);
> +               if (!session)
> +                       continue;
> +               percpu_counter_set(&session->i_caps_hit, 0);
> +               percpu_counter_set(&session->i_caps_mis, 0);
> +               ceph_put_mds_session(session);
> +       }
> +
> +       mutex_unlock(&mdsc->mutex);
> +
> +       return 0;
> +}
> +
> +DEFINE_SIMPLE_ATTRIBUTE(reset_metrics_fops, NULL, reset_metrics_set, "%llu\n");
> +
>  static int metric_show(struct seq_file *s, void *p)
>  {
>         struct ceph_fs_client *fsc = s->private;
> @@ -355,6 +404,7 @@ void ceph_fs_debugfs_cleanup(struct ceph_fs_client *fsc)
>         debugfs_remove(fsc->debugfs_caps);
>         debugfs_remove(fsc->debugfs_metric);
>         debugfs_remove(fsc->debugfs_sending_metrics);
> +       debugfs_remove(fsc->debugfs_reset_metrics);
>         debugfs_remove(fsc->debugfs_mdsc);
>  }
>
> @@ -402,6 +452,13 @@ void ceph_fs_debugfs_init(struct ceph_fs_client *fsc)
>                                             fsc,
>                                             &sending_metrics_fops);
>
> +       fsc->debugfs_reset_metrics =
> +                       debugfs_create_file("reset_metrics",
> +                                           0600,
> +                                           fsc->client->debugfs_dir,
> +                                           fsc,
> +                                           &reset_metrics_fops);
> +
>         fsc->debugfs_metric = debugfs_create_file("metrics",
>                                                   0400,
>                                                   fsc->client->debugfs_dir,
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index a91431e9bdf7..d24929f1c4bf 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -129,6 +129,7 @@ struct ceph_fs_client {
>         struct dentry *debugfs_bdi;
>         struct dentry *debugfs_mdsc, *debugfs_mdsmap;
>         struct dentry *debugfs_sending_metrics;
> +       struct dentry *debugfs_reset_metrics;
>         struct dentry *debugfs_metric;
>         struct dentry *debugfs_mds_sessions;
>  #endif

Do we need a separate attribute for this?  Did you think about making
metrics attribute writeable and accepting some string, e.g. "reset"?

Thanks,

                Ilya
