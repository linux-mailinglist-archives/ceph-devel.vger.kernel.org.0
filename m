Return-Path: <ceph-devel+bounces-2235-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7504A9E1599
	for <lists+ceph-devel@lfdr.de>; Tue,  3 Dec 2024 09:25:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 33B9F280F65
	for <lists+ceph-devel@lfdr.de>; Tue,  3 Dec 2024 08:25:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D4EC1B21AA;
	Tue,  3 Dec 2024 08:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="V/3Gk3Mx"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BF2718732E
	for <ceph-devel@vger.kernel.org>; Tue,  3 Dec 2024 08:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733214346; cv=none; b=b3tp75aZzV40fqWqvZ7vH9tWaSbVSeHbLkNhTZyKeHkkoL4opJ9RBu0tpgZAQ0fibyA/cahG9n5ewzs5xKvQk5OnxiY2eRdPRaxwrLTD1iTjOwFodB6GA01BtVERPJwZwK8p2YMqnsC6bPg8T44USaxnBopgtlqfYlBuYWD71Lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733214346; c=relaxed/simple;
	bh=XzYqKNu9nkIPwas6xXZ0FrSh0QWx6MX4C/dhJXAYoQQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=flHVqnt7Fn5rFqxdLAuelTpeb+WXMMf8ahRP63D4aZuDM39QJhf020y0iuOfwpOQo4YENr36m9+cyy9qds2JmUFVKr1ySr2YAepQYAEpZz74rqBJNKNsEGBdWkg96yKdEj+90GiRfxmxwc0nUATxV8u7qufPRtee4H12qHXz+xQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=V/3Gk3Mx; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4349fb56260so45387985e9.3
        for <ceph-devel@vger.kernel.org>; Tue, 03 Dec 2024 00:25:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1733214343; x=1733819143; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NFVyGAOoUGvBTdn4OKYkzDZyUFswDw+amMRXH6epu9A=;
        b=V/3Gk3Mx3wzHx5dVK5MDsT4PC/jaMopcDKcRVnBr4wI09/ckLaisDWCX2VrGV39LHb
         ussIXGI80lU1+BVDk/OVosipUHYnDO1DQADq0tVKeZNr7gBB6jxx7DjLbjmojCUHd9d3
         +gkcAJelkxTM7X10V/I8YK7HDViIFqS5/5rY+msQ6t7UICNFpWeY/clIYuagH83387ss
         m7Nt6iLcTn2KGPuoHCn/vrzqalQstKXiDp/+6r6W+0qjX17QpuremcmxRLC54/rPje5n
         +y9+xBsV1gxWNnL2wo6bHhnFjERBIPJumC3Ehgq0wohi5S/zobIT0DUknrWQlGYfDlgB
         6zmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733214343; x=1733819143;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NFVyGAOoUGvBTdn4OKYkzDZyUFswDw+amMRXH6epu9A=;
        b=uW+X2+tpZIdWoSW0n2GfhSghRm/riSqrcrU3Ki9CV6yLeAJTpjPNhvBP7Ihm0dj6ch
         iLWCar/DwnFRGw7IB/IyPtFrq5hTpFb7UqCNe5sxMhJb+/e5DojaCnHmZmrQDfMa61MV
         XUjcR8ioJKd3g/4B6BdJa6/t20A3vuXsuTtMisjUTLcsS7K+aO2Fg3ZWVxHlmGQCPPxY
         6ky4Txb1MjxOpwZyYH6VKxMYuGaSBCLww4yC0waDpYDHJ1d1RsQgdF1JqEdFySq/SSdZ
         vFK1Xn9skExFfo2N6rwVHn/pFt2xt4l517ly/TK84ejuooDY2JHc4+K42Es2NdY+biKM
         Y7WA==
X-Gm-Message-State: AOJu0YwZj72S1AtMzkywAE+iKwsQ8NP1i7S7C6ncxgukJ1S6klkpKqQt
	leOBvpOFWpX1rd6YR9RNrdt9b8fYfXFsXqjGkE3rQGdUE17ybxj+sdykJrx4XN4=
X-Gm-Gg: ASbGncuMOSJ1E4wwIz7ULAH/VL9nNfQY4zcEfjXF1KhpuwibhHus4MZxWjAArl9p8M5
	feQ/n0OVA8B+mKYyjOy+2Z/IHeyJtLmtdZAB0dMXtvJi6JnU9GXi+1MNJEbTfY7iDGCkUD/iLUu
	n0VBcXzqS5325v4nW70b8fFX7BGfPrN5x5LwYQAJtysY+c3jiaTprF+uIgXw8LqXSQYenw6Qmaz
	o2yYpr6EXMAegrsG0uFaJ1Sn2yb87ou4ViHD/6A1df4EwCdmXLbEx0=
X-Google-Smtp-Source: AGHT+IEMgobTKebkHRD4omQV0cwZktGSEpv//UezyWb8mKoHybRdTgDwd5vsZmL5HZJmKl/MgTEamQ==
X-Received: by 2002:a5d:6d08:0:b0:385:e0d6:fb73 with SMTP id ffacd0b85a97d-385fd3ebb0bmr1485670f8f.15.1733214343515;
        Tue, 03 Dec 2024 00:25:43 -0800 (PST)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-434aa74f1f6sm216878265e9.8.2024.12.03.00.25.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Dec 2024 00:25:42 -0800 (PST)
Date: Tue, 3 Dec 2024 11:25:39 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Jeff Layton <jlayton@kernel.org>
Cc: ceph-devel@vger.kernel.org
Subject: Re: [bug report] ceph: decode interval_sets for delegated inos
Message-ID: <f0d05d36-742f-456e-a0a1-a3c1c78ff20a@stanley.mountain>
References: <e660f348-5a0e-486d-8bae-e6c229f0e047@stanley.mountain>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e660f348-5a0e-486d-8bae-e6c229f0e047@stanley.mountain>

On Tue, Dec 03, 2024 at 11:19:25AM +0300, Dan Carpenter wrote:
> Hello Jeff Layton,
> 
> Commit d48464878708 ("ceph: decode interval_sets for delegated inos")
> from Nov 15, 2019 (linux-next), leads to the following Smatch static
> checker warning:
> 
> 	fs/ceph/mds_client.c:644 ceph_parse_deleg_inos()
> 	warn: potential user controlled sizeof overflow 'sets * 2 * 8' '0-u32max * 8'
> 
> fs/ceph/mds_client.c
>     637 static int ceph_parse_deleg_inos(void **p, void *end,
>     638                                  struct ceph_mds_session *s)
>     639 {
>     640         u32 sets;
>     641 
>     642         ceph_decode_32_safe(p, end, sets, bad);
>                                             ^^^^
> set to user data here.
> 
>     643         if (sets)
> --> 644                 ceph_decode_skip_n(p, end, sets * 2 * sizeof(__le64), bad);
>                                                    ^^^^^^^^^^^^^^^^^^^^^^^^^
> This is safe on 64bit but on 32bit systems it can integer overflow/wrap.
> 

Smatch has similar warnings in ceph_mdsmap_decode().

fs/ceph/mdsmap.c:228 ceph_mdsmap_decode() warn: potential user controlled sizeof overflow 'num_export_targets * 4' '0-u32max * 4'
fs/ceph/mdsmap.c:280 ceph_mdsmap_decode() warn: potential user controlled sizeof overflow '8 * (n + 1)' '8 * s32min-s32max'
fs/ceph/mdsmap.c:337 ceph_mdsmap_decode() warn: potential user controlled sizeof overflow '4 * n' '4 * 0-u32max'
fs/ceph/mdsmap.c:339 ceph_mdsmap_decode() warn: potential user controlled sizeof overflow '4 * n' '4 * 0-u32max'

regards,
dan carpenter


