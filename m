Return-Path: <ceph-devel+bounces-2234-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C4DCA9E156B
	for <lists+ceph-devel@lfdr.de>; Tue,  3 Dec 2024 09:19:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8ADDF2833BF
	for <lists+ceph-devel@lfdr.de>; Tue,  3 Dec 2024 08:19:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F61A1BBBD6;
	Tue,  3 Dec 2024 08:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="AV3DphiE"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11C79156F45
	for <ceph-devel@vger.kernel.org>; Tue,  3 Dec 2024 08:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733213973; cv=none; b=j965bAPR1/2XvTRL4clnp5J7wUbMjxYUOaAbOHtYb8S3vTwuz1pk8qpfzqVwX0+RTbBlmUVR+dgT5RsRVrGsCVCLp5HvYi6eGrGO0V/4Ca90YevzUkgCQpdt65BfviKaaOjH67TIUQ7qAsPYLVNlUpNuMvuPEWgX9hHRHUPjtGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733213973; c=relaxed/simple;
	bh=CT3flI5MSZRLGe31ZvetFWAz38ZRx/cj92KqTckeTvI=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=HRTHYnm2Yjtdjiuwfjsmtp57Yfvizn14MLUHLIMWNjePTV3K6ZEUDXeDUQcNZsWkpUC6k7OS5rCmc9zDHrx8ThMOYxdXCzcn6v7oYI9psn6MTnzgwbKBrLVQ5ZkZLFdFXk4Ff76wSmEbj/O3fUM6CiMf3wtMF1bEtkIZAP3ErKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=AV3DphiE; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-434a0fd9778so48025965e9.0
        for <ceph-devel@vger.kernel.org>; Tue, 03 Dec 2024 00:19:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1733213970; x=1733818770; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=e77DH73xR/tMgD1a9KUNIxih80kMLkFz3EJqpPpw/bI=;
        b=AV3DphiE4vdY2s1qGvLnyrld+OI5p6+4Z0bbZQYp0fTWlx1eyjkiakmOervWA9vkU1
         T5fnBUYNHFShVrD53DVhS76c+95zycCjg5l+OKvKM4K0kfwRrRj2zj90auej4WE7cJkv
         wl/tDMcK+yFM84BPAKm6kjj9Bb31botjX/FG+6wwpcxAbMijuNbn9EwdYKLdNrONp6zZ
         phBuKx2hMien3cH6Wdf/M4k+hmi467kIKK1us7DEN5ZVVXoTuv2+H0jXmVFGttjtcfC9
         jUvL+Ee15+eG5rrv28XIIKs52nN8YXh3GBYPz+GMIjZTyqP2Br+/pfeR9nAZsH4jGd0P
         3aHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733213970; x=1733818770;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=e77DH73xR/tMgD1a9KUNIxih80kMLkFz3EJqpPpw/bI=;
        b=NgS58NLGpPNhjEmI0B2l95L72ip9uZEJgxXTEHQj8Gbbs4V6xmwS3XD1ZblvKvSrlq
         Kzo3sHeSEpI3Bv43+y1RtvTEpbAumSrFUp9HR8GAvQtrahTrKSnyk6/sbX5DYz2d3ZFT
         4ziha+eNYl30u4632UaB86YypBrVuZaXKil/gSKyS/YbgZPRDxL+QtHjkGpoMGMjSVFK
         8pK4lsdDOvSh3ftGyhAva2i0HldI0g3iu8E2cK5hH9eR12ufvUo0SYKY6SPvz3fATQ4j
         hhf5PTFyuVfV3PUcbJunwSZyCtl91sE3p3uFBPX7PJ/dG+mw4ZsjFNtv2BUjZ0fw/VhR
         kGYQ==
X-Gm-Message-State: AOJu0YxucQHkrtu4TzjdB9y8+RycP7DUB9Do2sQ+rDqlKxa+5So1sPI6
	8GL0ungUuBE/snfAKY+9zoisKS8AmL98spr9JE2aBgM7KV2QjkOsA5Lu0/YAgUg=
X-Gm-Gg: ASbGncvSou2neMnuxPAh3R43b/SkoH10MTZ89TrC36HG4/+LFalPlrPDuCNE/piB3+M
	wTEwefY59vXAh80++TFCq9dgm5O9hvnG3wZYlUtf0AeKxelNrQMEnFoAb1RjEl4jLGzhvuscZcq
	qzSsWvT64LgyMvz14BITwXwkZxwSBb4aa1p82q1FK6dyYzM7gjPJTjl/VyXKDC2Vzx0LG6BzSAI
	ot1okLz+e/qGL2MDeMHNc4y4M/pSXFRHfNxM44tAKWgdK8NxYyaDBI=
X-Google-Smtp-Source: AGHT+IGZc3vh+6ZvzsUAqSHxwSOU6UEzDo1CTD8B7L4hvrqloIF024oKOWXDIEVNrp1nwpHrBC9r3w==
X-Received: by 2002:a05:6000:71c:b0:385:e4a7:df07 with SMTP id ffacd0b85a97d-385fd421308mr1287579f8f.42.1733213970393;
        Tue, 03 Dec 2024 00:19:30 -0800 (PST)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-385e940fef3sm8431817f8f.42.2024.12.03.00.19.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Dec 2024 00:19:29 -0800 (PST)
Date: Tue, 3 Dec 2024 11:19:25 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Jeff Layton <jlayton@kernel.org>
Cc: ceph-devel@vger.kernel.org
Subject: [bug report] ceph: decode interval_sets for delegated inos
Message-ID: <e660f348-5a0e-486d-8bae-e6c229f0e047@stanley.mountain>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Jeff Layton,

Commit d48464878708 ("ceph: decode interval_sets for delegated inos")
from Nov 15, 2019 (linux-next), leads to the following Smatch static
checker warning:

	fs/ceph/mds_client.c:644 ceph_parse_deleg_inos()
	warn: potential user controlled sizeof overflow 'sets * 2 * 8' '0-u32max * 8'

fs/ceph/mds_client.c
    637 static int ceph_parse_deleg_inos(void **p, void *end,
    638                                  struct ceph_mds_session *s)
    639 {
    640         u32 sets;
    641 
    642         ceph_decode_32_safe(p, end, sets, bad);
                                            ^^^^
set to user data here.

    643         if (sets)
--> 644                 ceph_decode_skip_n(p, end, sets * 2 * sizeof(__le64), bad);
                                                   ^^^^^^^^^^^^^^^^^^^^^^^^^
This is safe on 64bit but on 32bit systems it can integer overflow/wrap.

    645         return 0;
    646 bad:
    647         return -EIO;
    648 }
    649 
    650 u64 ceph_get_deleg_ino(struct ceph_mds_session *s)
    651 {
    652         return 0;
    653 }
    654 

regards,
dan carpenter

