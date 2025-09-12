Return-Path: <ceph-devel+bounces-3596-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 73529B54355
	for <lists+ceph-devel@lfdr.de>; Fri, 12 Sep 2025 08:53:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BDAF41C864FD
	for <lists+ceph-devel@lfdr.de>; Fri, 12 Sep 2025 06:53:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D10F2951B3;
	Fri, 12 Sep 2025 06:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b="nSe9+r/Z"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79B8F28A3F2
	for <ceph-devel@vger.kernel.org>; Fri, 12 Sep 2025 06:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757659980; cv=none; b=LKuD8TH6i0sdxF6X7AfNb8EqgXfpvrmdo03bSgGMW5kKHRzBQjgT6143Fpzj7IvOVKJ0yjcsDYHFnZ6SSyOJ+ABZmkAmlVXR4EWoj+oCjtdt/E10I+yltG6mwfRe9KXTqYoul/59JbhlV2b9YWYxVnL8By06kUcBRIxYMAutzY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757659980; c=relaxed/simple;
	bh=AMQ9UJhJn6NJ6YO0XjNRfud58VDObW+dwpThmQIOhd8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=F2D7UJa7fN9scjVBgO/jyVPj10Uz3UihrilrMeuzsnRYtILT/YhqqXxusRj2on0X3MNp7FdKznvqv3pSduKCeInmnQm6TVbrGgrQrqHsb9gzk9HyJmhFXvnXL/2d/VjiRykqKsXiwkYoH6sZn8eV++pSf2gGlDv6BCnTXxV0ZGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw; spf=pass smtp.mailfrom=gms.tku.edu.tw; dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b=nSe9+r/Z; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gms.tku.edu.tw
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-772301f8a4cso2169395b3a.3
        for <ceph-devel@vger.kernel.org>; Thu, 11 Sep 2025 23:52:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gms-tku-edu-tw.20230601.gappssmtp.com; s=20230601; t=1757659978; x=1758264778; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AMQ9UJhJn6NJ6YO0XjNRfud58VDObW+dwpThmQIOhd8=;
        b=nSe9+r/ZU5y7WEJgrf9f3rUh1nS6uir2QVa1uhENhODP3KSZhst0fiV8hwOMzKe3uV
         BaXXTCHv7KBAQcEhfcXOYvF0AFuOzMOPY8u0hpVN7GDLeAxRyEOckWk5sD2PXkPIv0xg
         hx7VMz6C0YF6URuzBm0+PlinXwn3/cUi6RHIR+vNHqPW+du2i0dFk1qf7jnnYYcjzi7I
         crwNb53jn0Dt3y/rVPffjs+Nzh81BOZOZLT4iwUQzdKLzd+ZDi2ipqBHsBkb26TEJInc
         Zy6iq8s8ufk66lTTGc7ZOnUdpIWOdVM0shpZPuB4XpCoQZxg3akIVNVIYw5GDpfXUqqa
         RQxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757659978; x=1758264778;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AMQ9UJhJn6NJ6YO0XjNRfud58VDObW+dwpThmQIOhd8=;
        b=qz1yMD19AYlGyFE1yz0mPE++ip44LDT6KPm0UZN5amGQ7s4PGGqDXkLKQNZTUZQarS
         ZLbgjWmv6gWu0nK5+p5EhfYYD1zk6uXSPWKWbQOpm1BKSxS4aDi5zFGDQPS1hS5JX5vJ
         WqeKOJb7izupZC5qHluuekveSqEiZn2FRzFnL1oJvQyNdyCo0G2QmDeFqL3GiuVsTzao
         kje7oabt+5OHOXazZ4/4zXktJrH9whqbxso3DRh13Kqmq8xkgUNwcbxe9lSg02QSlzMe
         JV/KoQyMB/vGsYD+ESB1ZvCgzYze2WH6uZ7fNS1h0mQdz1CYL555qG8MyV3Xrvzs2sJG
         hQ4g==
X-Forwarded-Encrypted: i=1; AJvYcCUFGTSJ990ZajggHusgWyAN8iPQL1bV2VATEgL+DGot38WHo70jjoHSZkzuWkOD0EXqNrE998JgtgKS@vger.kernel.org
X-Gm-Message-State: AOJu0YwHaPE7tMJw+A2RBWnpe/rd7wt7SRgKyTRMlzZrXr/R5Zu1MAu7
	k7q/su1FXvX5TwG/NTJKCh2Wh7Kuvza8cne9DC+2jAaVxsw8KVb+SvJNn95CHbEHJg4=
X-Gm-Gg: ASbGncuDl3VARQImVjoMc5yK2RfjqLilzq0dzMvt62SxEc0F69V5Gm9VgK3rYBtr+eJ
	zJsYvd2MaMAcNAs7UaqiXCxf1yJaWLOLk6lQeX1Ml3fv4Cbl1WrTxvaTbqAbv78D2KNqtELMLuf
	NGaAozsuEiPKuIrR5E7qZP3wlt2rzLl2ivs6FVdf+qak5CmUUqIHSpDbN9g0N+Ud8r2B+Z9jTPe
	61U7I+JvEWMOJM93u0GWS026QNXkdE18MQGCRTcJhrhubrcPcxjLrVaeribkSt8ssijCtQT1IfP
	1QrQx253OpHFcHIpp9BQ6vE1tc8XLQQ1Ti6W8o3nbO7LSNJEU3WX7A831P4jq+E8a3J8E81i+56
	1EcdmOn3e+pb3whEbzj9/mPOioSCE64g8z6qOVLYc7CRIanQ=
X-Google-Smtp-Source: AGHT+IFQKeePLPos3Wc/vCSrtfD9DK3M1OpdAn6C2aQwDSA3Qht9Qgg36mVj/vePp62ddGIi74wlig==
X-Received: by 2002:a05:6a00:2ea2:b0:76e:2eff:7ae9 with SMTP id d2e1a72fcca58-77612092482mr1980655b3a.12.1757659977712;
        Thu, 11 Sep 2025 23:52:57 -0700 (PDT)
Received: from wu-Pro-E500-G6-WS720T.. ([2001:288:7001:2703:9e14:1074:637d:9ff6])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-77607c49fe4sm4410985b3a.101.2025.09.11.23.52.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Sep 2025 23:52:56 -0700 (PDT)
From: Guan-Chun Wu <409411716@gms.tku.edu.tw>
To: 409411716@gms.tku.edu.tw
Cc: akpm@linux-foundation.org,
	axboe@kernel.dk,
	ceph-devel@vger.kernel.org,
	ebiggers@kernel.org,
	hch@lst.de,
	home7438072@gmail.com,
	idryomov@gmail.com,
	jaegeuk@kernel.org,
	kbusch@kernel.org,
	linux-fscrypt@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	sagi@grimberg.me,
	tytso@mit.edu,
	visitorckw@gmail.com,
	xiubli@redhat.com
Subject: Re: [PATCH v2 2/5] lib/base64: rework encoder/decoder with customizable support and update nvme-auth
Date: Fri, 12 Sep 2025 14:52:52 +0800
Message-Id: <20250912065252.857420-1-409411716@gms.tku.edu.tw>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <aMO/woLrAN7bn9Fd@wu-Pro-E500-G6-WS720T>
References: <aMO/woLrAN7bn9Fd@wu-Pro-E500-G6-WS720T>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Sorry, please ignore my previous email. My email client was not configured correctly.

Best regards,
Guan-chun

