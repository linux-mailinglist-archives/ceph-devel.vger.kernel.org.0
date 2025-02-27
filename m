Return-Path: <ceph-devel+bounces-2828-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 781ADA47C96
	for <lists+ceph-devel@lfdr.de>; Thu, 27 Feb 2025 12:51:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 708E57A394F
	for <lists+ceph-devel@lfdr.de>; Thu, 27 Feb 2025 11:50:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 436B26FB0;
	Thu, 27 Feb 2025 11:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WGTQN4KC"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A6A2374F1
	for <ceph-devel@vger.kernel.org>; Thu, 27 Feb 2025 11:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740657051; cv=none; b=dJrDbvDTAtZY1Nu5JKdOgLov8iIebY8M2VDqAY+AXNXqMOlDfIQ1M7NDtnECvDVZhN/znGXnxXmIyPjra0GKxCdjhNdW8SgiR8fDFoB0SVa/jwNdDlZD6NDI+0Dls6E2I9HmjhqkzF0Qjfd11u2tV2p+/El383bqG2O/vffV+GE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740657051; c=relaxed/simple;
	bh=yKAuSfY4EC9hKkpQLnLAqxIX35QWGQUL8x8Ejtrw21w=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=WbudM4rT8G+FOhdVS6gPINxG8K9eLCysyREW5nCJlRUdBt7dU6JGPg+dxmR/QiFEMuTP6f0bEBGADT59Lr9NTtyGRf99Uy28ia+s/pkI4AVVuXqcUSWdhsQyEHxkGOiRPFFEDA0kBXeua+eHUhHZnp8gVFkJ0Iewk5eqBPF4tXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WGTQN4KC; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740657048;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=u4WRhXLcMgDw7WEiQrv5HGgWrYFFJRieAg1ZfNG2Z58=;
	b=WGTQN4KCcRrgDOCd/bQYJc3S2i8/Q/I1Lsx1u7+aL1di5mwdmpIBVvJgXZbYC/Gb/hOzh9
	NzRd99s6BTEqjlupog65Npdw4hPS5DBCMkUIM1FpV/9Yk8Li1ujC61nIOyTHmTL9ST7BsI
	CB8SDx6XqpCM8WFV1RM1wWQZkb1YvuY=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-617-8z2YctUfN6iih9GSRYn4sQ-1; Thu,
 27 Feb 2025 06:50:44 -0500
X-MC-Unique: 8z2YctUfN6iih9GSRYn4sQ-1
X-Mimecast-MFC-AGG-ID: 8z2YctUfN6iih9GSRYn4sQ_1740657043
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C756E1800877;
	Thu, 27 Feb 2025 11:50:42 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.44.32.200])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1FF7E1800352;
	Thu, 27 Feb 2025 11:50:39 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20250226190515.314845-1-slava@dubeyko.com>
References: <20250226190515.314845-1-slava@dubeyko.com>
To: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: dhowells@redhat.com, ceph-devel@vger.kernel.org, amarkuze@redhat.com,
    idryomov@gmail.com, linux-fsdevel@vger.kernel.org,
    pdonnell@redhat.com, Slava.Dubeyko@ibm.com
Subject: Re: [PATCH v2] ceph: fix slab-use-after-free in have_mon_and_osd_map()
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3148391.1740657038.1@warthog.procyon.org.uk>
Date: Thu, 27 Feb 2025 11:50:38 +0000
Message-ID: <3148392.1740657038@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Viacheslav Dubeyko <slava@dubeyko.com> wrote:

> This patch fixes the issue by means of locking
> client->osdc.lock and client->monc.mutex before
> the checking client->osdc.osdmap and
> client->monc.monmap.

You've also added clearance of a bunch of pointers into destruction and error
handling paths (can I recommend you mention it in the commit message?).  Is
that a "just in case" thing?  It doesn't look like the client can get
resurrected afterwards, but I may have missed something.  If it's not just in
case, does the access and clearance of the pointers need wrapping in the
appropriate lock?

> --- a/net/ceph/debugfs.c
> +++ b/net/ceph/debugfs.c
> @@ -36,18 +36,20 @@ static int monmap_show(struct seq_file *s, void *p)
>  	int i;
>  	struct ceph_client *client = s->private;
>  
> -	if (client->monc.monmap == NULL)
> -		return 0;
> -
> -	seq_printf(s, "epoch %d\n", client->monc.monmap->epoch);
> -	for (i = 0; i < client->monc.monmap->num_mon; i++) {
> -		struct ceph_entity_inst *inst =
> -			&client->monc.monmap->mon_inst[i];
> -
> -		seq_printf(s, "\t%s%lld\t%s\n",
> -			   ENTITY_NAME(inst->name),
> -			   ceph_pr_addr(&inst->addr));
> +	mutex_lock(&client->monc.mutex);
> +	if (client->monc.monmap) {
> +		seq_printf(s, "epoch %d\n", client->monc.monmap->epoch);
> +		for (i = 0; i < client->monc.monmap->num_mon; i++) {
> +			struct ceph_entity_inst *inst =
> +				&client->monc.monmap->mon_inst[i];
> +
> +			seq_printf(s, "\t%s%lld\t%s\n",
> +				   ENTITY_NAME(inst->name),
> +				   ceph_pr_addr(&inst->addr));
> +		}
>  	}
> +	mutex_unlock(&client->monc.mutex);
> +
>  	return 0;
>  }
>  

You might want to look at using RCU for this (though not necessarily as part
of this fix).

Apart from that:

Reviewed-by: David Howells <dhowells@redhat.com>

David


