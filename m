Return-Path: <ceph-devel+bounces-3025-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A52E2AA642E
	for <lists+ceph-devel@lfdr.de>; Thu,  1 May 2025 21:43:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 649611B651A3
	for <lists+ceph-devel@lfdr.de>; Thu,  1 May 2025 19:43:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B259C225A39;
	Thu,  1 May 2025 19:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b="coR3mkAI"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B8D61EB5D0
	for <ceph-devel@vger.kernel.org>; Thu,  1 May 2025 19:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746128592; cv=none; b=uKjp8fzJxS+1Dr8m8PNnmkGYlKs55R2eU/X6E5/+3q2LpBkVuMbW1vk6d5QqUJiA6X9yEyTkPwexyCZpWAGKVLvhKlQOqWXe24f2soihLA29WLRtyzGo1NLyrAg8NB9dUEuP1Ecz9xt21L/f/KyIGqOwFEJMTIii9hvWpSsFZO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746128592; c=relaxed/simple;
	bh=2aon5cRP+l1B2JTpKPoPuiku93oRe55ZyVy7IR8uchI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XIvsuRvV9xI8TR4KR5EWz2WB0kQqo4JjeuZCfCpxrAa3d2LXMWxsr7wkl4dEGUopNrkw8xiyY+MTI0bj0zykGlNo93fyQshLdxNrMzX+XmBcgNKD9/o4hYj8sduZ+be+i+PmlUx/wRnbJB6KBU2PXqC/agiJ1QNKXx8wdzrkxbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b=coR3mkAI; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-7376dd56eccso1581117b3a.0
        for <ceph-devel@vger.kernel.org>; Thu, 01 May 2025 12:43:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20230601.gappssmtp.com; s=20230601; t=1746128589; x=1746733389; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=QP6+EvCruX6vsDt1kQkwAU2ri+es0FOsVPQVgd1gBBQ=;
        b=coR3mkAID/oLP3kcoix0ydIF6OhkG9+xmt1EFAlEWWleGTB7xsFZ6PTXlFnEYor6qo
         JJ+WJ19F2TIoml3haczObfen9SCG/zvY43B6m4raNaanTH5cZEbMBw5ZiuGSg9bXxxKm
         su0KLOjCkvzht4Jf2LLn8CAfWJ4KLP1x7EMXgHczAqngLJzk8Jq11HeC7SjRm3pVkt4X
         WqLr1SsBCKMuX4vRB/9x/aH1zmq2xCHyYeY4uexfShv/xxlaWA8RvP3FWrLPv5ydUCzW
         fbkhgxLMF1w+VCW2Zkk2UpfZFfgKz8oqJvqxjLvzygOwvzhj106OIX6gpFpleTi7Obo4
         Ws4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746128589; x=1746733389;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QP6+EvCruX6vsDt1kQkwAU2ri+es0FOsVPQVgd1gBBQ=;
        b=gJNhl2p1yDQKgt7DvqM484Tmcrg8sJUM0aIUwzVojH0m7Ev/TIKOFpyMzYlwS2O4NP
         yv7TlxCvsoW+xwQUrMjff9DjEhN+zndg7kYeZwYKpV5Km9jTgl16VdwUCACoSy8FJ9/I
         cvpHc4uysS0WFx0lg/1OoI2+n9e0duHu8OX4d33yxGWG9GL2ur3G6WcH3k365bOO/Pm3
         OybwtiVOG3poAWfyvieoSatNfMiF6uwd7ugPiXxfl2km68zzvpwcfjJLBoCQ0f4G3TyK
         Z/1u3mUeuxo8wgxVB9ewTFQxfYW/yEyofPE1aGuVRiHpDU4YbNtY8irudOjlfBv6vX4M
         Z1+w==
X-Gm-Message-State: AOJu0YxBHxwtdPMUWsLDtCToSYWRJv0r3DfxID1ALOliGERVUjKWzWcI
	0mrvVaa1zxYgorRJH0E7XKFpnWuciARoJusffjoirjSRtIXHYivAu/QCKvKlh3O/XSD6NOE35aG
	zZLk=
X-Gm-Gg: ASbGnct4fGQLlh4gQgvSNYChDt6AABkXUKYiLW8tBFH/TfeskFNYxJSSvTDhJ0jdZtF
	jr5N49Kdl9NxTyY5kpVp7xUnsYyQLHn/U0ZO+BjNJpW6UGmTNKZjzli/hNnjTpK0i13qFeWRSbC
	9+J6MqQcpMWaPv0n/n7oRnD9rXmT9ixVFZkyO9viwO0M03t3iZKssByjrGtv4EAQbR/w5FzF70s
	rrOlBLwQX0JeMDvSIDRrsjxz3t/xZHAznWSymQXIFm8SJNk+ub0HvDV/EFwPLJcoOctsbW4BGms
	i7e8azdYdgU87jNv/mMfrCDvJMezEcWOl4numX+kGMbLV3APBAOUupD14Q==
X-Google-Smtp-Source: AGHT+IEW/Lia9WlDQZ0wFSoMPXJ2hOVQ3v13RQyspU7E7JrjsY6BGGMuQkdYDaoFLW1SueBr5DmLXg==
X-Received: by 2002:a05:6a00:448c:b0:736:592e:795f with SMTP id d2e1a72fcca58-74058a20d67mr268114b3a.9.1746128589556;
        Thu, 01 May 2025 12:43:09 -0700 (PDT)
Received: from system76-pc.attlocal.net ([2600:1700:6476:1430:7a9:d9dd:47b7:3886])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74058dc45basm50882b3a.69.2025.05.01.12.43.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 May 2025 12:43:08 -0700 (PDT)
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	linux-fsdevel@vger.kernel.org,
	pdonnell@redhat.com,
	amarkuze@redhat.com,
	Slava.Dubeyko@ibm.com,
	slava@dubeyko.com
Subject: [RFC PATCH 0/2] ceph: cleanup of hardcoded invalid ID
Date: Thu,  1 May 2025 12:42:46 -0700
Message-ID: <20250501194248.660959-1-slava@dubeyko.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>

This patchset introduces CEPH_INVALID_CACHE_IDX
instead of hardcoded value. Also, it reworks ceph_readdir()
logic by introducing BUG_ON() for debug case and
introduces WARN_ON() for release case.

Viacheslav Dubeyko (2):
  ceph: introduce CEPH_INVALID_CACHE_IDX
  ceph: exchange BUG_ON on WARN_ON in ceph_readdir()

 fs/ceph/Kconfig | 13 +++++++++++++
 fs/ceph/dir.c   | 33 ++++++++++++++++++++++++---------
 fs/ceph/file.c  |  2 +-
 fs/ceph/super.h |  8 ++++++++
 4 files changed, 46 insertions(+), 10 deletions(-)

-- 
2.48.0


