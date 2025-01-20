Return-Path: <ceph-devel+bounces-2517-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F24AA16E56
	for <lists+ceph-devel@lfdr.de>; Mon, 20 Jan 2025 15:20:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 97AC53A55B0
	for <lists+ceph-devel@lfdr.de>; Mon, 20 Jan 2025 14:20:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21B3D1E2847;
	Mon, 20 Jan 2025 14:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OP83E2O+"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 472D21DED7B
	for <ceph-devel@vger.kernel.org>; Mon, 20 Jan 2025 14:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737382814; cv=none; b=DwlD+DTbIXv1BDNeKYlD1z60uaiGXy+UxD5/V88f71mc6/Lr5LWjU7QQGCG6TikTI1gAtsn+AD/RGe8YuTrjvJrfGCDoXp2BDmBbCSf2Q/qj2ozC5LwhAyj0XjWUSMhVFjUg4PBjevVjTkqfrXaL6WQhyTVX00dafqLVU9NHdMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737382814; c=relaxed/simple;
	bh=9NZu06CxTDRuui9ZtxDmk+RjDbkXQGug+FqITFrQcSU=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=G1ZBB4NDSU/9LIqvH9r6WwSaJ1kjdeQ8VwDZcBl43kD3RWJTfzOcEAnmFxPlXcQ3IyUPH9j15aNGONX2YJkiFDb2ElxeCyHjc2chcvv7WMk0oxVyFQjcfg4HMXEzHYsL+CkV+5AtKW0y0uCaWwntnFJtPSV7w/yyu4NDxgmxh20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OP83E2O+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737382812;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TreBfTv+ANrAZzRZLge8UyjLin+9L5DJqMl3TBXduVI=;
	b=OP83E2O+L81cHTnBUop+rJTKTcjVsurlAfnlTrBEdSoArSq0SQaQUIuuOJ+0NCA/s+9/nA
	ww7TdQOlz54DFfDNqOoDQB2QK5dp1MX5vsBEYrEkuZBNRxtqa7whpaa19JqpZAGtRNkLF4
	wy+/5eRTRhv4CGPQgABvUaljD8oi15w=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-526-fxiocTgFO7CKfLZKoU1q6Q-1; Mon,
 20 Jan 2025 09:20:10 -0500
X-MC-Unique: fxiocTgFO7CKfLZKoU1q6Q-1
X-Mimecast-MFC-AGG-ID: fxiocTgFO7CKfLZKoU1q6Q
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 36F7819560BB;
	Mon, 20 Jan 2025 14:20:09 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.5])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C6AF419560AE;
	Mon, 20 Jan 2025 14:20:07 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1113699.1737376348@warthog.procyon.org.uk>
References: <1113699.1737376348@warthog.procyon.org.uk>
To: Eric Biggers <ebiggers@google.com>
Cc: dhowells@redhat.com, Alex Markuze <amarkuze@redhat.com>,
    fstests@vger.kernel.org, ceph-devel@vger.kernel.org,
    linux-fsdevel@vger.kernel.org
Subject: Re: Error in generic/397 test script?
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1201002.1737382806.1@warthog.procyon.org.uk>
Date: Mon, 20 Jan 2025 14:20:06 +0000
Message-ID: <1201003.1737382806@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

generic/429 can also hang:


	show_file_contents()
	{
		echo "--- Contents of files using plaintext names:"
		cat $SCRATCH_MNT/edir/@@@ |& _filter_scratch
		cat $SCRATCH_MNT/edir/abcd |& _filter_scratch
		echo "--- Contents of files using no-key names:"
		cat ${nokey_names[@]} |& _filter_scratch | _filter_nokey_filenames edir
	}
	...
	nokey_names=( $(find $SCRATCH_MNT/edir -mindepth 1 | sort) )
	printf '%s\n' "${nokey_names[@]}" | \
		_filter_scratch | _filter_nokey_filenames edir
	show_file_contents

on the 'cat ...' at the end of show_file_contents().  A check that
${nokey_names[0]} is not nothing might be in order.

However, in this case (in which I'm running these against ceph), I don't think
that the find should return nothing, so it's not a bug in the test script per
se.

David


