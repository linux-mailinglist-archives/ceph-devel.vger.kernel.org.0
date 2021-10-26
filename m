Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1774843B252
	for <lists+ceph-devel@lfdr.de>; Tue, 26 Oct 2021 14:22:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232671AbhJZMZH (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 26 Oct 2021 08:25:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:43354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233913AbhJZMZH (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 26 Oct 2021 08:25:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 11CFD60C51;
        Tue, 26 Oct 2021 12:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635250963;
        bh=VVITy1iXeMmu2uvVQFJGl7MtIbpBSaPSA2mMIaPRLlk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=BxoNJ10crovHoCJmrFcz3yOXtg5LDyxI4XEEnMX6NT9+mYJfmxuAFfdRVB53gAM1l
         0/+T9vzAfiajGuj0mpqgkrcNhD3b91ebo+U3NJoWOFIGIWbZaYCMTWFr5SUyUNictm
         6jTEcglSYm0y1wxkQ1hch/MNPUu30Z0Awq5na1bYcRCoJfbewpeu+McfETJM1lusVc
         y2yb5O78ITXOx1PloV6tKcbcO2sDXTe9Wc7d5wi3Av0pTyPChcElQAVnnYZEy1g2kI
         ae4ZAR890oSzkWYBMOvF/hAIfEd3sFX39VhI1OjUQMdlPViOfPBLUPOkooPPRf5DZx
         nDr0tMJTanKjg==
Message-ID: <0bcf4c3c831f8e4ebb872aaa409077eea40ceb67.camel@kernel.org>
Subject: Re: [RFC PATCH v2] ceph: add remote object copy counter to fs
 client metrics
From:   Jeff Layton <jlayton@kernel.org>
To:     =?ISO-8859-1?Q?Lu=EDs?= Henriques <lhenriques@suse.de>,
        Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Patrick Donnelly <pdonnell@redhat.com>
Date:   Tue, 26 Oct 2021 08:22:41 -0400
In-Reply-To: <20211025150042.1677-1-lhenriques@suse.de>
References: <20211025150042.1677-1-lhenriques@suse.de>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.4 (3.40.4-2.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2021-10-25 at 16:00 +0100, Luís Henriques wrote:
> This counter will keep track of the number of remote object copies done on
> copy_file_range syscalls.  This counter will be kept using the metrics
> infrastructure and thus accessible through debugfs.  For now, this counter
> won't be sent to the MDS.
> 
> Cc: Patrick Donnelly <pdonnell@redhat.com>
> Signed-off-by: Luís Henriques <lhenriques@suse.de>
> ---
> Hi!
> 
> So, here's v2 of this RFC.  Now, I guess that Patrick's idea of adding
> this counter was to validate the test results, isn't that right?  If so,
> this has to be done from within the fstest code and not from teuthology
> test.  The reason is that fstests mount and unmount the filesystems under
> test, which effectively wipe the metrics on the client.
> 
> So, the follow-up to this patch would be changes to the corresponding
> fstests so that they would access this debugfs file and check the counter
> is set to the expected value.
> 
> Cheers,
> --
> Luís
> 
>  fs/ceph/debugfs.c | 6 ++++++
>  fs/ceph/file.c    | 1 +
>  fs/ceph/metric.c  | 2 ++
>  fs/ceph/metric.h  | 2 ++
>  4 files changed, 11 insertions(+)
> 
> diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
> index 38b78b45811f..9f1a09816541 100644
> --- a/fs/ceph/debugfs.c
> +++ b/fs/ceph/debugfs.c
> @@ -235,6 +235,12 @@ static int metric_show(struct seq_file *s, void *p)
>  		   percpu_counter_sum(&m->i_caps_mis),
>  		   percpu_counter_sum(&m->i_caps_hit));
>  
> +	seq_printf(s, "\n");
> +	seq_printf(s, "item          total\n");
> +	seq_printf(s, "-------------------\n");
> +	seq_printf(s, "%-14s%-16lld\n", "copy-from",
> +		   atomic64_read(&m->total_copyfrom));
> +
>  	return 0;
>  }
>  
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index e61018d9764e..b36a7b9c1ab8 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -2253,6 +2253,7 @@ static ssize_t ceph_do_objects_copy(struct ceph_inode_info *src_ci, u64 *src_off
>  				bytes = ret;
>  			goto out;
>  		}
> +		atomic64_inc(&fsc->mdsc->metric.total_copyfrom);
>  		len -= object_size;
>  		bytes += object_size;
>  		*src_off += object_size;
> diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
> index 04d5df29bbbf..a8a9f96c56a8 100644
> --- a/fs/ceph/metric.c
> +++ b/fs/ceph/metric.c
> @@ -278,6 +278,8 @@ int ceph_metric_init(struct ceph_client_metric *m)
>  	if (ret)
>  		goto err_total_inodes;
>  
> +	atomic64_set(&m->total_copyfrom, 0);
> +
>  	m->session = NULL;
>  	INIT_DELAYED_WORK(&m->delayed_work, metric_delayed_work);
>  
> diff --git a/fs/ceph/metric.h b/fs/ceph/metric.h
> index 0133955a3c6a..a1e2cd46de6b 100644
> --- a/fs/ceph/metric.h
> +++ b/fs/ceph/metric.h
> @@ -169,6 +169,8 @@ struct ceph_client_metric {
>  	struct percpu_counter opened_inodes;
>  	struct percpu_counter total_inodes;
>  
> +	atomic64_t total_copyfrom;
> +
>  	struct ceph_mds_session *session;
>  	struct delayed_work delayed_work;  /* delayed work */
>  };


I know the main interest currently is just the count of ops, but I do
think that we'll want a full set of stats like we track for
reads/writes, and I'd rather not rev the file format any more than we
need to.

Could you extend struct ceph_client_metric with a full set of copy stats
and plumb in the places to record and report them? It should be pretty
similar to how reads/writes are tracked.
-- 
Jeff Layton <jlayton@kernel.org>

