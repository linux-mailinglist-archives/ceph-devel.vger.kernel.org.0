Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C19332AD68B
	for <lists+ceph-devel@lfdr.de>; Tue, 10 Nov 2020 13:42:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730099AbgKJMmu (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 10 Nov 2020 07:42:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:38020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726900AbgKJMmu (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 10 Nov 2020 07:42:50 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 27ECB20781;
        Tue, 10 Nov 2020 12:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605012169;
        bh=q5xUsjZlZpk3ena/um0/AhPIH9XRzVJ7WLomz6Y8vbY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=cUgW6JqMAyUYMRDbF1g7LRl9EcILK5jqlWzOp8kVfJonGzbx3HsP/NfMWcZvsaw5X
         Yxq1PxycSm6HVqCI1sIwyCSrMm06Y45xmPbjTcf3yL0IsC92tx/N2JpFchDG1ip8rT
         RCTLWeqGY3FtIup9hv2BNszxYGvGxBd7ywzQglQ8=
Message-ID: <1de1d95563ea399083a20eaf2f8d840dde00e72a.camel@kernel.org>
Subject: Re: [PATCH v2] libceph: add osd op counter metric support
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com, idryomov@gmail.com
Cc:     zyan@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
Date:   Tue, 10 Nov 2020 07:42:46 -0500
In-Reply-To: <20201110110118.340544-1-xiubli@redhat.com>
References: <20201110110118.340544-1-xiubli@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.1 (3.38.1-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2020-11-10 at 19:01 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> The logic is the same with osdc/Objecter.cc in ceph in user space.
> 
> URL: https://tracker.ceph.com/issues/48053
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
> 
> V2:
> - remove other not used counter metrics
> 
>  include/linux/ceph/osd_client.h |  9 ++++++
>  net/ceph/debugfs.c              | 13 ++++++++
>  net/ceph/osd_client.c           | 56 +++++++++++++++++++++++++++++++++
>  3 files changed, 78 insertions(+)
> 
> diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
> index 83fa08a06507..24301513b186 100644
> --- a/include/linux/ceph/osd_client.h
> +++ b/include/linux/ceph/osd_client.h
> @@ -339,6 +339,13 @@ struct ceph_osd_backoff {
>  	struct ceph_hobject_id *end;
>  };
>  
> 
> 
> 
> +struct ceph_osd_metric {
> +	struct percpu_counter op_ops;
> +	struct percpu_counter op_rmw;
> +	struct percpu_counter op_r;
> +	struct percpu_counter op_w;
> +};
> +
>  #define CEPH_LINGER_ID_START	0xffff000000000000ULL
>  
> 
> 
> 
>  struct ceph_osd_client {
> @@ -371,6 +378,8 @@ struct ceph_osd_client {
>  	struct ceph_msgpool	msgpool_op;
>  	struct ceph_msgpool	msgpool_op_reply;
>  
> 
> 
> 
> +	struct ceph_osd_metric  metric;
> +
>  	struct workqueue_struct	*notify_wq;
>  	struct workqueue_struct	*completion_wq;
>  };
> diff --git a/net/ceph/debugfs.c b/net/ceph/debugfs.c
> index 2110439f8a24..af90019386ab 100644
> --- a/net/ceph/debugfs.c
> +++ b/net/ceph/debugfs.c
> @@ -339,6 +339,16 @@ static void dump_backoffs(struct seq_file *s, struct ceph_osd *osd)
>  	mutex_unlock(&osd->lock);
>  }
>  
> 
> 
> 
> +static void dump_op_metric(struct seq_file *s, struct ceph_osd_client *osdc)
> +{
> +	struct ceph_osd_metric *m = &osdc->metric;
> +
> +	seq_printf(s, "  op_ops: %lld\n", percpu_counter_sum(&m->op_ops));
> +	seq_printf(s, "  op_rmw: %lld\n", percpu_counter_sum(&m->op_rmw));
> +	seq_printf(s, "  op_r:   %lld\n", percpu_counter_sum(&m->op_r));
> +	seq_printf(s, "  op_w:   %lld\n", percpu_counter_sum(&m->op_w));
> +}
> +
>  static int osdc_show(struct seq_file *s, void *pp)
>  {
>  	struct ceph_client *client = s->private;
> @@ -372,6 +382,9 @@ static int osdc_show(struct seq_file *s, void *pp)
>  	}
>  
> 
> 
> 
>  	up_read(&osdc->lock);
> +
> +	seq_puts(s, "OP METRIC:\n");
> +	dump_op_metric(s, osdc);
>  	return 0;
>  }
>  
> 
> 
> 
> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> index 7901ab6c79fd..66774b2bc584 100644
> --- a/net/ceph/osd_client.c
> +++ b/net/ceph/osd_client.c
> @@ -2424,6 +2424,21 @@ static void __submit_request(struct ceph_osd_request *req, bool wrlocked)
>  	goto again;
>  }
>  
> 
> 
> 
> +static void osd_acount_op_metric(struct ceph_osd_request *req)
> +{
> +	struct ceph_osd_metric *m = &req->r_osdc->metric;
> +
> +	percpu_counter_inc(&m->op_ops);
> +
> +	if ((req->r_flags & (CEPH_OSD_FLAG_READ | CEPH_OSD_FLAG_READ))
> +	    == (CEPH_OSD_FLAG_READ | CEPH_OSD_FLAG_READ))
> +		percpu_counter_inc(&m->op_rmw);

What's the point of or'ing the same flag together, and how is this
different from the read one below? Was it supposed to be or'ed with
CEPH_OSD_FLAG_WRITE ?

> +	if (req->r_flags & CEPH_OSD_FLAG_READ)
> +		percpu_counter_inc(&m->op_r);
> +	else if (req->r_flags & CEPH_OSD_FLAG_WRITE)
> +		percpu_counter_inc(&m->op_w);
> +}
> +
>  static void account_request(struct ceph_osd_request *req)
>  {
>  	WARN_ON(req->r_flags & (CEPH_OSD_FLAG_ACK | CEPH_OSD_FLAG_ONDISK));
> @@ -2434,6 +2449,8 @@ static void account_request(struct ceph_osd_request *req)
>  
> 
> 
> 
>  	req->r_start_stamp = jiffies;
>  	req->r_start_latency = ktime_get();
> +
> +	osd_acount_op_metric(req);
>  }
>  
> 
> 
> 
>  static void submit_request(struct ceph_osd_request *req, bool wrlocked)
> @@ -5205,6 +5222,39 @@ void ceph_osdc_reopen_osds(struct ceph_osd_client *osdc)
>  	up_write(&osdc->lock);
>  }
>  
> 
> 
> 
> +static void ceph_metric_destroy(struct ceph_osd_metric *m)
> +{
> +	percpu_counter_destroy(&m->op_ops);
> +	percpu_counter_destroy(&m->op_rmw);
> +	percpu_counter_destroy(&m->op_r);
> +	percpu_counter_destroy(&m->op_w);
> +}
> +
> +static int ceph_metric_init(struct ceph_osd_metric *m)
> +{
> +	int ret;
> +
> +	memset(m, 0, sizeof(*m));
> +
> +	ret = percpu_counter_init(&m->op_ops, 0, GFP_NOIO);
> +	if (ret)
> +		return ret;
> +	ret = percpu_counter_init(&m->op_rmw, 0, GFP_NOIO);
> +	if (ret)
> +		goto err;
> +	ret = percpu_counter_init(&m->op_r, 0, GFP_NOIO);
> +	if (ret)
> +		goto err;
> +	ret = percpu_counter_init(&m->op_w, 0, GFP_NOIO);
> +	if (ret)
> +		goto err;
> +	return 0;
> +
> +err:
> +	ceph_metric_destroy(m);
> +	return ret;
> +}
> +
>  /*
>   * init, shutdown
>   */
> @@ -5257,6 +5307,9 @@ int ceph_osdc_init(struct ceph_osd_client *osdc, struct ceph_client *client)
>  	if (!osdc->completion_wq)
>  		goto out_notify_wq;
>  
> 
> 
> 
> +	if (ceph_metric_init(&osdc->metric) < 0)
> +		goto out_completion_wq;
> +
>  	schedule_delayed_work(&osdc->timeout_work,
>  			      osdc->client->options->osd_keepalive_timeout);
>  	schedule_delayed_work(&osdc->osds_timeout_work,
> @@ -5264,6 +5317,8 @@ int ceph_osdc_init(struct ceph_osd_client *osdc, struct ceph_client *client)
>  
> 
> 
> 
>  	return 0;
>  
> 
> 
> 
> +out_completion_wq:
> +	destroy_workqueue(osdc->completion_wq);
>  out_notify_wq:
>  	destroy_workqueue(osdc->notify_wq);
>  out_msgpool_reply:
> @@ -5302,6 +5357,7 @@ void ceph_osdc_stop(struct ceph_osd_client *osdc)
>  	WARN_ON(atomic_read(&osdc->num_requests));
>  	WARN_ON(atomic_read(&osdc->num_homeless));
>  
> 
> 
> 
> +	ceph_metric_destroy(&osdc->metric);
>  	ceph_osdmap_destroy(osdc->osdmap);
>  	mempool_destroy(osdc->req_mempool);
>  	ceph_msgpool_destroy(&osdc->msgpool_op);

-- 
Jeff Layton <jlayton@kernel.org>

