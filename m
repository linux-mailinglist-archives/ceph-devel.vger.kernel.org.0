Return-Path: <ceph-devel+bounces-2965-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BDE42A67FEB
	for <lists+ceph-devel@lfdr.de>; Tue, 18 Mar 2025 23:42:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8E9833A9AEB
	for <lists+ceph-devel@lfdr.de>; Tue, 18 Mar 2025 22:42:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C97F62063FD;
	Tue, 18 Mar 2025 22:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q3+B90ZZ"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC74D2063C7
	for <ceph-devel@vger.kernel.org>; Tue, 18 Mar 2025 22:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742337735; cv=none; b=HUX9muMNHdwkyVmMZeWf0SoWVTrxMBu3LxsKUvo3gt7VHB1H6h3F7bd8HVPDbHUo2JDjQWn4tva/v9vOaeJG1Bk6sSpXzFmA53KdqZEAhkdGBCeIc+DbCyJmNIJjh9r/DcRbe4yngKluvKn6sAlTh5MGnmhwmgbShd7fTw7FCPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742337735; c=relaxed/simple;
	bh=zOAlt16IQRcpwn5o6uE5dGh4K0PN9XCU/M1F0Vroj6U=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=ZSmQ19jq6Rp6k7Jyhgse55/1QzJ/7GPTrtNLaG1CyZESQc5e9cTz3CvdnhmDw9WLuD95rkl4iNxQliJ6TI/hQ3NYt5b4CtitBt6j7SavWgLJY4gyIs/hAmYmmcZ4DarvuZRGZBwLQfcBCRLBM/KZDf5pa4jRnUpLs42GlOsUkSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Q3+B90ZZ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742337732;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p/pE272q4mZo4yJ6A+9oqBEIILJWQNI9Vpnvw1MS7w8=;
	b=Q3+B90ZZMRqHtpQUPVbfCN3tfptoVVHqlQl6Qnln5RJwRNXeDt6jNGlipjSKGh4WFMxaGe
	zQNKhBQoK6BldWGNN6BVfBN5NfgksArTQBbvgo7JvrVI0UrjULvUyvK9q+qEFnxUE4aEP3
	mt1ziExsScSZVEhpZ0HEYBbgOm6rN1s=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-363-Hxm9bpgpOkWw7d1GVI43iA-1; Tue,
 18 Mar 2025 18:42:09 -0400
X-MC-Unique: Hxm9bpgpOkWw7d1GVI43iA-1
X-Mimecast-MFC-AGG-ID: Hxm9bpgpOkWw7d1GVI43iA_1742337728
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1D9381800258;
	Tue, 18 Mar 2025 22:42:08 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.61])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id CACD11956095;
	Tue, 18 Mar 2025 22:42:06 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <Z9nFlkVcXIII8Zdi@debian>
References: <Z9nFlkVcXIII8Zdi@debian> <Z9m7wY8dGAlq4z0K@debian> <80300ccacebc13ee67100fe256b03f08dfd2819e.camel@dubeyko.com>
To: Fan Ni <nifan.cxl@gmail.com>
Cc: dhowells@redhat.com, slava@dubeyko.com, ceph-devel@vger.kernel.org,
    Slava.Dubeyko@ibm.com
Subject: Re: Question about code in fs/ceph/addr.c
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2681464.1742337725.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Tue, 18 Mar 2025 22:42:05 +0000
Message-ID: <2681465.1742337725@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Hi Fan,

My aim is to get rid of all page/folio handling from the main part of the
filesystem entirely and use netfslib instead.  See:

	https://lore.kernel.org/linux-fsdevel/20250313233341.1675324-1-dhowells@r=
edhat.com/T/#u

Now, this is a work in progress, but I think I have a decent shot at havin=
g it
ready for the next merge window after the one that should open in about a
week.

Note that there, struct ceph_snap_context is built around a netfs_group st=
ruct
and attachment to folios is handled by netfslib as much as possible.

My patches can be obtained here:

	https://web.git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git=
/log/?h=3Dceph-iter

David


