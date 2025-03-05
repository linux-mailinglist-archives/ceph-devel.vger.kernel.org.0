Return-Path: <ceph-devel+bounces-2863-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 60088A5050D
	for <lists+ceph-devel@lfdr.de>; Wed,  5 Mar 2025 17:36:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 476FC18831E3
	for <lists+ceph-devel@lfdr.de>; Wed,  5 Mar 2025 16:34:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 808BCBA27;
	Wed,  5 Mar 2025 16:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M9Bgr8zg"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFCDB45C18
	for <ceph-devel@vger.kernel.org>; Wed,  5 Mar 2025 16:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741192462; cv=none; b=LdQzsqxJrc2d/bdHs7s7v6iEmMiLC1Fa6ir8OV4ztuB+R7ZIOYAOtBuAqdRd/eXTiWgWu/LAr8j5COuCHbhI/Ru2TTadUtaRy/Q2H5MaJoIWHsZKwbUPrzEuIhHya8BfbOGgGb1KpV+AuUBKpt8SuOXAf/eybvrAzYrB1K1yGa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741192462; c=relaxed/simple;
	bh=MvcvTZROJ3YamGgkejX20F8DFgN4bMQ5gW19e6QGox4=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=uU23HGSqJCgrr9q+rh1HXGvkhFyKiW5iQUvWHurCn/K8VVkB/sgZVK8c2py9ZeS7e2wDJ8canmABnuW1zEB33W8WshcZOmkMdYB9CR3KgBlxphtiThayD4BuJWddSrXQEZAdWT1p8QPnxbK5WeBj5CCNMK5V1MkiyN5Pixo2Fsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=M9Bgr8zg; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741192459;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MXm3fOyBN0R7dMmHNgkn5/hPY8QOMikcdewS0mfYvqk=;
	b=M9Bgr8zg1rdoN4ZwIuymGZv5pumvsJOu9Cc27ER1JLYszM4P7BL4segf6hudK4zge3Qlww
	HhtLZ06FOt6LK5QCiQHvpW8OSO9XpaIQlfHT8tl1zdpxvKFWTEG0UqyHNxpZF1nHtdBf0J
	iouahVbio4zKOJWg4g3mKJXhzfLzXYQ=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-111-C-2xn6rMMuGyUpMotejvxw-1; Wed,
 05 Mar 2025 11:34:11 -0500
X-MC-Unique: C-2xn6rMMuGyUpMotejvxw-1
X-Mimecast-MFC-AGG-ID: C-2xn6rMMuGyUpMotejvxw_1741192450
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F1E61180035C;
	Wed,  5 Mar 2025 16:34:09 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.44.32.200])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id F089E18001F5;
	Wed,  5 Mar 2025 16:34:06 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <3989572.1734546794@warthog.procyon.org.uk>
References: <3989572.1734546794@warthog.procyon.org.uk>
To: Alex Markuze <amarkuze@redhat.com>,
    Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
    Ilya Dryomov <idryomov@gmail.com>
Cc: dhowells@redhat.com, Xiubo Li <xiubli@redhat.com>,
    Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org,
    netfs@lists.linux.dev, linux-fsdevel@vger.kernel.org
Subject: Is EOLDSNAPC actually generated? -- Re: Ceph and Netfslib
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4170996.1741192445.1@warthog.procyon.org.uk>
Date: Wed, 05 Mar 2025 16:34:05 +0000
Message-ID: <4170997.1741192445@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Hi Alex, Slava,

I'm looking at making a ceph_netfs_write_iter() to handle writing to ceph
files through netfs.  One thing I'm wondering about is the way
ceph_write_iter() handles EOLDSNAPC.  In this case, it goes back to
retry_snap and renegotiates the caps (amongst other things).  Firstly, does it
actually need to do this?  And, secondly, I can't seem to find anything that
actually generates EOLDSNAPC (or anything relevant that generates ERESTART).

Is it possible that we could get rid of the code that handles EOLDSNAPC?

David


