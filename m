Return-Path: <ceph-devel+bounces-2684-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E8CAA366DB
	for <lists+ceph-devel@lfdr.de>; Fri, 14 Feb 2025 21:29:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 636923B1D49
	for <lists+ceph-devel@lfdr.de>; Fri, 14 Feb 2025 20:29:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 577D71A2385;
	Fri, 14 Feb 2025 20:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FEW7h/pP"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BFD419066D
	for <ceph-devel@vger.kernel.org>; Fri, 14 Feb 2025 20:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739564977; cv=none; b=CjAEhVi5ZtTlQ4XoyCv5nbvk/eqD0N0P1H+npFBOAzOYqcxVdqudfWygN4AcHmXv6H1jfF8nCDqWc7xf8SWgwNPoEip9BFEuzUHBKh/1FhWm+qPPdPkpuG3mACx2YtTqWKtUWuHIxZaWwGEn/mmdol/RDdtgHzW80wSHaQ3mzDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739564977; c=relaxed/simple;
	bh=1uaP1d2sLA+8C3VqKAyaEw+qF7wwJHctclvNHKHDj1g=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=kGf9jaM3IqW8ratLzkHMN6qoaAGvQaVQSEaPDP/e60a0sjf8UKnpsrr/yM3Dk3y7wbOwNy4rKd6mAUtPBmiiyH6FsCnHiJBk+hK6+1mjWbqPy37fZMBxdIohXkNuNtFSWy2np51HyQ5zfCCMLWOkve2lsyvz8qAhHAR5MpxLvlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FEW7h/pP; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739564974;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=c8A56lR9/Hy0OlmZRM31DYAC0QTHZRP692d8y79gV0k=;
	b=FEW7h/pPb2YylydTm0QgG/9xvkJ9ZYnix1+vHrjk86s5oUBc18+gY2UFvG88ww/bS01e41
	nTPuLIB1O7zfSkQsVTQj6iBVoeNt/MLhbqQYce73dDMsBpaIkxY73dJWaSpO8L64IGGDr1
	UwZF8dokfFtL3eSz7kf57m9qRcYlS8E=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-621-7-wIRc_CNce8x2dlntqXAQ-1; Fri,
 14 Feb 2025 15:29:33 -0500
X-MC-Unique: 7-wIRc_CNce8x2dlntqXAQ-1
X-Mimecast-MFC-AGG-ID: 7-wIRc_CNce8x2dlntqXAQ_1739564972
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E9F601800264;
	Fri, 14 Feb 2025 20:29:31 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.9])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8293B19373C4;
	Fri, 14 Feb 2025 20:29:29 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20250117035044.23309-1-slava@dubeyko.com>
References: <20250117035044.23309-1-slava@dubeyko.com>
To: Viacheslav Dubeyko <slava@dubeyko.com>,
    Matthew Wilcox <willy@infradead.org>
Cc: dhowells@redhat.com, ceph-devel@vger.kernel.org, idryomov@gmail.com,
    linux-fsdevel@vger.kernel.org, amarkuze@redhat.com,
    Slava.Dubeyko@ibm.com
Subject: Re: [PATCH v2] ceph: Fix kernel crash in generic/397 test
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <17774.1739564968.1@warthog.procyon.org.uk>
Date: Fri, 14 Feb 2025 20:29:28 +0000
Message-ID: <17775.1739564968@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Are these patches on a git branch somewhere?  The patches I got from Willy to
do the folio conversion of ceph are going to need a bit of updating after
these fixes.

David


