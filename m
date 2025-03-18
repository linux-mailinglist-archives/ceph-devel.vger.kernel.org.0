Return-Path: <ceph-devel+bounces-2963-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D378CA67FCE
	for <lists+ceph-devel@lfdr.de>; Tue, 18 Mar 2025 23:28:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1EDC71B601EC
	for <lists+ceph-devel@lfdr.de>; Tue, 18 Mar 2025 22:27:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B20820DD45;
	Tue, 18 Mar 2025 22:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QgpSbe32"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2601206F14
	for <ceph-devel@vger.kernel.org>; Tue, 18 Mar 2025 22:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742336838; cv=none; b=Z8P69TGsWESS2ENBtVLtvAsiQPUemhLCfYJzeviGLoXBTrdiAgKwB+svVbAjDuZsAUul1fe2tyguCHq9fHphynWSdHGrGIuyxdRmbW4bRS+xlXucnzyrO3nFAS9AF5lxJe5c0Woj+NZXMel8NZQFKYtm9SedUTQ1m+xmJVoFjHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742336838; c=relaxed/simple;
	bh=mn8ciSZM7TzSdMWoRAmxUj268/ACb2sMPk8DNE7dNaQ=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=Qoehsi1ltQtbgRchi82X5FjUGPEMhoRsMyYn0R/8pzEm2UHThrmbbL0acskiB3r0L6JlJqu1fro6yUqo3qymtFy6CGUBIrXon3pxnlQMEDWrS5Jb43zkvQ+1MatbwwNLH25KyiLIKW+sl9v9HTz1l8BjlB2pwPB3pJk0WJyIBb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QgpSbe32; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742336834;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6vJdlI3UJeMtCRnyHVRGZoKUZQprA89U08X2gYyoWMo=;
	b=QgpSbe329EKRba3LDdjFskA9pVG0y++bGwXKyd6QTeH6tgolpF4AjGlWQz/XGFQMCisktz
	DEutdJ9HdN2/X0P7xddxmNkmIsKGwrRkHCvWUUwnSIcKe/m4MzuyiDssdFaOIta/KqX186
	Au7bEf+DFALYeKkaBQeDis7oyejpBLI=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-646-vM1uv3UQMFeoyx3DM-zW5A-1; Tue,
 18 Mar 2025 18:27:10 -0400
X-MC-Unique: vM1uv3UQMFeoyx3DM-zW5A-1
X-Mimecast-MFC-AGG-ID: vM1uv3UQMFeoyx3DM-zW5A_1742336829
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DA3A919560B0;
	Tue, 18 Mar 2025 22:27:08 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.61])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id CC3CE3001D0E;
	Tue, 18 Mar 2025 22:27:05 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <a8a3948417c0d1882f80c9f3870eeda23cb9ffd8.camel@ibm.com>
References: <a8a3948417c0d1882f80c9f3870eeda23cb9ffd8.camel@ibm.com> <20250313233341.1675324-1-dhowells@redhat.com> <20250313233341.1675324-20-dhowells@redhat.com>
To: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Cc: dhowells@redhat.com, Alex Markuze <amarkuze@redhat.com>,
    "slava@dubeyko.com" <slava@dubeyko.com>,
    "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
    "idryomov@gmail.com" <idryomov@gmail.com>,
    "jlayton@kernel.org" <jlayton@kernel.org>,
    "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
    "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
    "dongsheng.yang@easystack.cn" <dongsheng.yang@easystack.cn>,
    "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 19/35] libceph, ceph: Convert users of ceph_pagelist to ceph_databuf
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2680946.1742336824.1@warthog.procyon.org.uk>
Date: Tue, 18 Mar 2025 22:27:04 +0000
Message-ID: <2680947.1742336824@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Viacheslav Dubeyko <Slava.Dubeyko@ibm.com> wrote:

> >  		/*
> > -		 * number of encoded locks is stable, so copy to pagelist
> > +		 * number of encoded locks is stable, so copy to databuf
> >  		 */
> >  		struct_len = 2 * sizeof(u32) +
> >  			    (num_fcntl_locks + num_flock_locks) *
> 
> I think we have too many mysterious equations in CephFS code. :)

That's not particularly a function of these patches.

> > -		err = ceph_pagelist_reserve(pagelist,
> > -					    sizeof(u64) + sizeof(u32) +
> > -					    pathlen + sizeof(rec.v1));
> > +		err = ceph_databuf_reserve(dbuf,
> > +					   sizeof(u64) + sizeof(u32) +
> > +					   pathlen + sizeof(rec.v1),
> > +					   GFP_NOFS);
> 
> Yeah, another mysterious calculation. Why do we add sizeof(u64) and
> sizeof(u32) here?

Protocol element space.

David


