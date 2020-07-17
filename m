Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A83E7223A74
	for <lists+ceph-devel@lfdr.de>; Fri, 17 Jul 2020 13:24:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726079AbgGQLYg (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 17 Jul 2020 07:24:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:38814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726000AbgGQLYg (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 17 Jul 2020 07:24:36 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6CA6E20734;
        Fri, 17 Jul 2020 11:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594985076;
        bh=EbaDh7r2wmd2ITskN09q2XM/SMPl6V1xAclmaFPkkU8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=hij5dfa2hFFV/B42b3UAj5EImAFVojoRXqZAK0oVvnQy3rUWEPXrICe/uStIBE2L5
         0Czra5xbnMBlO80uSdDvsmsz/vKKt8kRO1mnYxXsh9Pfsem2vnT+DMJxSYLMbsqnYL
         dOlSz4UH3iFWrEYCsEY/25nEM6AM+G8viWNUHy74=
Message-ID: <fe0b6307eb3efe0d5cd8cbe87bde95d268cd7722.camel@kernel.org>
Subject: Re: [PATCH v6 1/2] ceph: periodically send perf metrics to ceph
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org, zyan@redhat.com,
        pdonnell@redhat.com, vshankar@redhat.com
Date:   Fri, 17 Jul 2020 07:24:33 -0400
In-Reply-To: <20200716140558.5185-2-xiubli@redhat.com>
References: <20200716140558.5185-1-xiubli@redhat.com>
         <20200716140558.5185-2-xiubli@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2020-07-16 at 10:05 -0400, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> This will send the caps/read/write/metadata metrics to any available
> MDS only once per second as default, which will be the same as the
> userland client. It will skip the MDS sessions which don't support
> the metric collection, or the MDSs will close the socket connections
> directly when it get an unknown type message.
> 
> We can disable the metric sending via the disable_send_metric module
> parameter.
> 
> URL: https://tracker.ceph.com/issues/43215
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/mds_client.c         |   4 +
>  fs/ceph/mds_client.h         |   4 +-
>  fs/ceph/metric.c             | 151 +++++++++++++++++++++++++++++++++++
>  fs/ceph/metric.h             |  77 ++++++++++++++++++
>  fs/ceph/super.c              |  42 ++++++++++
>  fs/ceph/super.h              |   2 +
>  include/linux/ceph/ceph_fs.h |   1 +
>  7 files changed, 280 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 9a09d12569bd..cf4c2ba2311f 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -3334,6 +3334,8 @@ static void handle_session(struct ceph_mds_session *session,
>  		session->s_state = CEPH_MDS_SESSION_OPEN;
>  		session->s_features = features;
>  		renewed_caps(mdsc, session, 0);
> +		if (test_bit(CEPHFS_FEATURE_METRIC_COLLECT, &session->s_features))
> +			metric_schedule_delayed(&mdsc->metric);
>  		wake = 1;
>  		if (mdsc->stopping)
>  			__close_session(mdsc, session);
> @@ -4303,6 +4305,7 @@ bool check_session_state(struct ceph_mds_session *s)
>  	}
>  	if (s->s_state == CEPH_MDS_SESSION_NEW ||
>  	    s->s_state == CEPH_MDS_SESSION_RESTARTING ||
> +	    s->s_state == CEPH_MDS_SESSION_CLOSED  ||

^^^
Is this an independent bugfix that should be a standalone patch? 



-- 
Jeff Layton <jlayton@kernel.org>

