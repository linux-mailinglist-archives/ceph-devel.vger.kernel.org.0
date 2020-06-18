Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A16C21FF507
	for <lists+ceph-devel@lfdr.de>; Thu, 18 Jun 2020 16:43:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727883AbgFROnh (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 18 Jun 2020 10:43:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:34902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726478AbgFROnh (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 18 Jun 2020 10:43:37 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 141D520885;
        Thu, 18 Jun 2020 14:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592491416;
        bh=H3xoY2enQpS6Tyf0l58TrGwOVynjvlCAMIkH56+ZH60=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=SrOQTckEKdmeiEMKyCMQkPOsQ7uwpBNiBAuTh//GWT+zLIk2dgFmnb3hREKvYy3dM
         i6wO4ITr1+5s9ix+KdoXfyDPg/myOPK8WJa9slcSjYBqOQg3Ztw8h9HY1JngDPzySw
         5PvoGeRTu5JbqyjHIIFFSaGq+KbLaSu1fhp0rH0Y=
Message-ID: <00a99a4873e2bb1dbfff995c2ff49fdbe5ea5aaf.camel@kernel.org>
Subject: Re: [PATCH v2 3/5] ceph: check the METRIC_COLLECT feature before
 sending metrics
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com, idryomov@gmail.com
Cc:     zyan@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
Date:   Thu, 18 Jun 2020 10:43:35 -0400
In-Reply-To: <1592481599-7851-4-git-send-email-xiubli@redhat.com>
References: <1592481599-7851-1-git-send-email-xiubli@redhat.com>
         <1592481599-7851-4-git-send-email-xiubli@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2020-06-18 at 07:59 -0400, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> Skip the MDS sessions if they don't support the metric collection,
> or the MDSs will close the socket connections directly when it get
> an unknown type message.
> 
> URL: https://tracker.ceph.com/issues/43215
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/mds_client.h | 4 +++-
>  fs/ceph/metric.c     | 8 ++++++++
>  2 files changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> index bcb3892..3c65ac1 100644
> --- a/fs/ceph/mds_client.h
> +++ b/fs/ceph/mds_client.h
> @@ -28,8 +28,9 @@ enum ceph_feature_type {
>  	CEPHFS_FEATURE_LAZY_CAP_WANTED,
>  	CEPHFS_FEATURE_MULTI_RECONNECT,
>  	CEPHFS_FEATURE_DELEG_INO,
> +	CEPHFS_FEATURE_METRIC_COLLECT,
>  
> -	CEPHFS_FEATURE_MAX = CEPHFS_FEATURE_DELEG_INO,
> +	CEPHFS_FEATURE_MAX = CEPHFS_FEATURE_METRIC_COLLECT,
>  };
>  
>  /*
> @@ -43,6 +44,7 @@ enum ceph_feature_type {
>  	CEPHFS_FEATURE_LAZY_CAP_WANTED,		\
>  	CEPHFS_FEATURE_MULTI_RECONNECT,		\
>  	CEPHFS_FEATURE_DELEG_INO,		\
> +	CEPHFS_FEATURE_METRIC_COLLECT,		\
>  						\
>  	CEPHFS_FEATURE_MAX,			\
>  }
> diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
> index 27cb541..4267b46 100644
> --- a/fs/ceph/metric.c
> +++ b/fs/ceph/metric.c
> @@ -127,6 +127,14 @@ static void metric_delayed_work(struct work_struct *work)
>  			continue;
>  		}
>  
> +		/*
> +		 * Skip it if MDS doesn't support the metric collection,
> +		 * or the MDS will close the session's socket connection
> +		 * directly when it get this message.
> +		 */
> +		if (!test_bit(CEPHFS_FEATURE_METRIC_COLLECT, &s->s_features))
> +			continue;
> +
>  		/* Only send the metric once in any available session */
>  		ret = ceph_mdsc_send_metrics(mdsc, s, nr_caps);
>  		ceph_put_mds_session(s);

This should probably be moved ahead of, or folded into the previous
patch to prevent a regression should someone land in between them when
bisecting.
-- 
Jeff Layton <jlayton@kernel.org>

