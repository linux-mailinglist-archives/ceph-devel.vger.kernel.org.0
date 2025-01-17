Return-Path: <ceph-devel+bounces-2496-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 83C74A14EDE
	for <lists+ceph-devel@lfdr.de>; Fri, 17 Jan 2025 12:57:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 983ED3A8AB1
	for <lists+ceph-devel@lfdr.de>; Fri, 17 Jan 2025 11:57:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B0721FECD3;
	Fri, 17 Jan 2025 11:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZKdY4jtv"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EB811FECAF
	for <ceph-devel@vger.kernel.org>; Fri, 17 Jan 2025 11:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737115029; cv=none; b=nwpx+uk/u0CiVncGygddJWoGEQAHOjfwkNWj8UDa8b/s3qRICxu1NFVHQfLTOz38VzDj7SxCd5aXBHwJ92Q0edsYwd4fVFdcZ94YeuONyupOI5q5TEVvIdkkzthY013cvfQoC1Wc04Vp8sdEiMpmHk0he/+sg3lZTMDRdt9Yp1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737115029; c=relaxed/simple;
	bh=PdsR6eDtPLGU0UCT2ZWFhbGcZ1xhlz6rKWTWzAO6NWg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YDUOeRwObUAytMcsOvGWvRCSNxP6eEizcQ7ATxuj8Qt8ONV8w2wBwKD9qYlzQFDzLmKcrxDdvdMjfHLcoT/EqhMP//p9w+F5Rrcxv/W9MHVOoY39gXOjAzpAXuVtJigmPmMuenQWb/8YpGijSFwzcuVKembWl0EIpOr/ZhvP/Ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZKdY4jtv; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737115025;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pQeV0O+jL1G/DFyqYGy9184NT6E7z1zePUvfpKkhxQI=;
	b=ZKdY4jtvWMN3MUhSBM45GYN3q0HIiLvq42cv2sVsOaruWoUdAIA2SsmE3y3wgDPl+XR+eI
	BQZuWC0l2wqn7jTJ3Ir01uGeV+zDxq70YPLGA3HWbV4wWtTyN40QJM+pUQpqGV+Yojnlgs
	OLFn6g3xMCGD8VWzt4NoS32pFvQpsr4=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-517-X-QMKzuZMpylKLq_glYHgA-1; Fri,
 17 Jan 2025 06:57:02 -0500
X-MC-Unique: X-QMKzuZMpylKLq_glYHgA-1
X-Mimecast-MFC-AGG-ID: X-QMKzuZMpylKLq_glYHgA
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7363919560BB;
	Fri, 17 Jan 2025 11:57:00 +0000 (UTC)
Received: from fedora (unknown [10.72.116.68])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9CA3F1955F10;
	Fri, 17 Jan 2025 11:56:53 +0000 (UTC)
Date: Fri, 17 Jan 2025 19:56:48 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	nbd@other.debian.org, ceph-devel@vger.kernel.org,
	virtualization@lists.linux.dev, linux-mtd@lists.infradead.org,
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 1/2] loop: force GFP_NOIO for underlying file systems
 allocations
Message-ID: <Z4pFgIqB50gz-ODi@fedora>
References: <20250117074442.256705-1-hch@lst.de>
 <20250117074442.256705-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250117074442.256705-2-hch@lst.de>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Fri, Jan 17, 2025 at 08:44:07AM +0100, Christoph Hellwig wrote:
> File systems can and often do allocate memory in the read-write path.
> If these allocations are done with __GFP_IO or __GFP_FS set they can
> recurse into the file system or swap device on top of the loop device
> and cause deadlocks.  Prevent this by forcing a noio scope over the
> calls into the file system.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/block/loop.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/block/loop.c b/drivers/block/loop.c
> index 1ec7417c7f00..71eccc5cfffb 100644
> --- a/drivers/block/loop.c
> +++ b/drivers/block/loop.c
> @@ -1905,6 +1905,15 @@ static void loop_handle_cmd(struct loop_cmd *cmd)
>  	int ret = 0;
>  	struct mem_cgroup *old_memcg = NULL;
>  	const bool use_aio = cmd->use_aio;
> +	unsigned int memflags;
> +
> +	/*
> +	 * We're calling into file system which could do be doing memory
> +	 * allocations.  Ensure the memory reclaim does not cause I/O,
> +	 * because that could end up in the user of this loop devices again and
> +	 * deadlock.
> +	 */
> +	memflags = memalloc_noio_save();

If we call memalloc_noio_save() here, setting PF_MEMALLOC_NOIO can be removed
from loop_process_work().


Thanks,
Ming


