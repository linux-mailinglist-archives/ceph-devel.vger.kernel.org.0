Return-Path: <ceph-devel+bounces-2829-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 48829A47CBA
	for <lists+ceph-devel@lfdr.de>; Thu, 27 Feb 2025 12:58:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 42CA73AF55E
	for <lists+ceph-devel@lfdr.de>; Thu, 27 Feb 2025 11:58:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7B601662EF;
	Thu, 27 Feb 2025 11:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KgVVszT9"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D8B622A1D1
	for <ceph-devel@vger.kernel.org>; Thu, 27 Feb 2025 11:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740657492; cv=none; b=FEwODCC9OJcP+nlsbaEAvEJm976FgV55Qx5qwG+tyRMGsJAve7UwMqY1DANkZp0nNUumqiJb0vYEKN30JYauObbi1q+Wx/Cd6J0nZgfermX42AIWTrl5POJHzAZnTAfxjUIGSrD/4f2YqNbkxhJKTBXQV7dFqjd8MEB5H+cLvaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740657492; c=relaxed/simple;
	bh=zKaWldZzJr0EE3LVrvOgBodvDVvBeS67tc5zaJwyGM0=;
	h=From:To:cc:Subject:MIME-Version:Content-Type:Date:Message-ID; b=KQDkZ9w8HQdomvEwNF6OmDWRoDFuhTbJj6+8rDK835jPTYu8wxzxv2lVckslxX5JHszJIyC3dFBzz92//2BvfV0ib1dN/jYH7V/YAGE6i+SNpKdFa4DekjEY3ctorHiScjKomdo4LnohsciEm6yRf9r7qWR9eNp6Zc0r70dRRDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KgVVszT9; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740657489;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=kZduchNWwmwrdYivwEi56JzPnjUQWb6YyNxlCQtfIy4=;
	b=KgVVszT9TT5RdxEok13emRbX76E3lJUEI5AK3YRi+sPUSv2uBv+tMsyBUtk5+PIQcGodSf
	9qgSYR1VQ8iDM+VnnliGCyIw/CX3dIBuDIP14EFY5Gi4jSNx69HUlmfqbsvvrUWCE24OyG
	Fy1QicEGWw/dtq5AKEBlils2HGwY+zo=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-422-madCrCwIOqOpyw9Zd985jQ-1; Thu,
 27 Feb 2025 06:58:06 -0500
X-MC-Unique: madCrCwIOqOpyw9Zd985jQ-1
X-Mimecast-MFC-AGG-ID: madCrCwIOqOpyw9Zd985jQ_1740657485
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2A4701801A28;
	Thu, 27 Feb 2025 11:58:05 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.44.32.200])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 881A119560AE;
	Thu, 27 Feb 2025 11:58:01 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: Christian Brauner <brauner@kernel.org>,
    Matthew Wilcox <willy@infradead.org>,
    Viacheslav Dubeyko <slava@dubeyko.com>
cc: dhowells@redhat.com, ceph-devel@vger.kernel.org, amarkuze@redhat.com,
    idryomov@gmail.com, linux-fsdevel@vger.kernel.org,
    pdonnell@redhat.com, Slava.Dubeyko@ibm.com
Subject: Can you take ceph patches and ceph mm changes into the VFS tree?
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3148603.1740657479.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Thu, 27 Feb 2025 11:58:00 +0000
Message-ID: <3148604.1740657480@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

Hi Christian,

Unless the ceph people would prefer to take them through the ceph tree, ca=
n
you consider taking the following fixes:

    https://lore.kernel.org/r/20250205000249.123054-1-slava@dubeyko.com/

into the VFS tree and adding:

    https://lore.kernel.org/r/20250217185119.430193-1-willy@infradead.org/

on top of that.  Willy's patches are for the next merge window, but are
rebased on top of Viacheslav's patches.

I have the patches here also:

    https://web.git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.=
git/log/?h=3Dceph-folio

Thanks,
David


