Return-Path: <ceph-devel+bounces-2930-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 95F37A60F4E
	for <lists+ceph-devel@lfdr.de>; Fri, 14 Mar 2025 11:51:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9011C1B62C17
	for <lists+ceph-devel@lfdr.de>; Fri, 14 Mar 2025 10:51:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A35D1FA272;
	Fri, 14 Mar 2025 10:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eNlU6o02"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 464691779AE
	for <ceph-devel@vger.kernel.org>; Fri, 14 Mar 2025 10:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741949495; cv=none; b=RhkWW6DzyItLTeYzv9H/E1qf7ZK1cAmiqUwIwXmsQprmsMoAZ87kLpOn6ljJYR6J+g3LOdLZuYpRcU00vMV7ssVMJW/b3U63/kOzwCRPe9wk2F5v/X0n9vJkadpJAZRYETd76cWBSXcAN1yowRRTx26me3keagCC3zhNlIXUhCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741949495; c=relaxed/simple;
	bh=jYbVGS3JNBieh91Rpx33dVuWOoVhvzg2SNa4f7zOGDU=;
	h=From:To:Cc:Subject:MIME-Version:Content-Type:Date:Message-ID; b=OOoXMVK2wYvzfoau/T0J1TgkrcPbsFO6lC88odSWlWLC97eaRJgfaXxsc1sweSCwQfMGNke0sVdlijEwZeM+oXc/VrqYxDT+93tXLZAbjt0TaH62nPzn9LtgWMPYdUWUGxxTRVTXnCRRQ3n/ExRSpTwwhKIp9oQwZvvooVoanfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eNlU6o02; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741949493;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=4Keg8dFO4gV2DbYC0wMMHXe6APvFiluW6ECZcpFg9dA=;
	b=eNlU6o02UiP2uv/aA61Y/3h9G55T5YpOepeUf6CvznBA5Ui6ZXS2YkOb3+zVRuRxStiu5i
	V9AnocU39WA6rKInWhRGJuRinErwMA+yLA1ZjiVkZ0zL+sEIKGLyI5fPARs2/vVJhouF0G
	cQJvnZxITkpuURjy06O5JBZy0K13KRs=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-692-VyBurzpqOHyRniMVozrO1Q-1; Fri,
 14 Mar 2025 06:51:29 -0400
X-MC-Unique: VyBurzpqOHyRniMVozrO1Q-1
X-Mimecast-MFC-AGG-ID: VyBurzpqOHyRniMVozrO1Q_1741949488
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B08B71800258;
	Fri, 14 Mar 2025 10:51:28 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.61])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9DEE81955BCB;
	Fri, 14 Mar 2025 10:51:26 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: Viacheslav Dubeyko <slava@dubeyko.com>,
    Alex Markuze <amarkuze@redhat.com>
Cc: David Howells <dhowells@redhat.com>,
    Ilya Dryomov <idryomov@gmail.com>, Jeff Layton <jlayton@kernel.org>,
    ceph-devel@vger.kernel.org
Subject: What are the I/O boundaries for read/write to a ceph object?
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1722308.1741949484.1@warthog.procyon.org.uk>
Date: Fri, 14 Mar 2025 10:51:25 +0000
Message-ID: <1722309.1741949485@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Hi Viacheslav, Alex,

Can you tell me what the I/O boundaries are for splitting up a read or a write
request into separate subrequests?

Does each RPC call need to fit within the bounds of an object or does it need
to fit within the bounds of a stripe/block?

Can a vectored read/write access multiple objects/blocks?

What I'm trying to do is to avoid using ceph_calc_file_object_mapping() as it
does a bunch of 128-bit divisions for which I don't need the answers.  I only
need xlen - and really, I just need the limits of the read or write I can
make.

Thanks,
David


