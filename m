Return-Path: <ceph-devel+bounces-2853-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 51537A4D7CD
	for <lists+ceph-devel@lfdr.de>; Tue,  4 Mar 2025 10:19:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2D98216CE89
	for <lists+ceph-devel@lfdr.de>; Tue,  4 Mar 2025 09:19:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B210D1FBC86;
	Tue,  4 Mar 2025 09:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dzqjPpA4"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9C111F4CA6
	for <ceph-devel@vger.kernel.org>; Tue,  4 Mar 2025 09:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741079948; cv=none; b=AcrHnH7vqyOvXYrhKVFMN/4b9KBNR7jqj675afX2uwZ2JFS6fcQGuexrQ8YlRQIu7Jnb4kX//mvmeemfiKooLnhlEBvwE2AptDQ3Ee3yHeuZTKOATDx8S+dMRVeZ4zzfPULcqZroK8WJqzNTt6wYdgvWRbnQWNJlE2rowYA8Fx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741079948; c=relaxed/simple;
	bh=KGwZpYRsAmKZAd3BpQqZyKuEpMliaI7OYSh8o7ApE10=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=lvPvT2OI6nsJc6f/Ybv/hXNj5ydlhEqeKgSNaiHn8vqqM/8EtbCLUNi6wAnY6vEsVNKvkqUhMEHpoBpBAI80kmgyQHOaF8G4EgVVeSrda4BALKbql5wtDOndA9HKLMJoNGsb2Ms804QzB8mhqyI2/661mhQyq2iQDj4tDGtZZ4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=dzqjPpA4; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3911748893aso315312f8f.3
        for <ceph-devel@vger.kernel.org>; Tue, 04 Mar 2025 01:19:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741079945; x=1741684745; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=N3AjM8ftIsOPsYgJWv0+oWMt9DGBIDRSnD7gYyAfq9k=;
        b=dzqjPpA4Ql3UbPDEZeW79mwKUJCW2lFpDCQ8dzwc/agPvsJOgRJEMR6kX7Qh7pEQcJ
         +8HrAz6e/ThNeoz1yhiYU4ofLE5k1p6X6t2k6HCyvrHbmdQCqnSzwiVjGYFY+z6OijrC
         hcNjQi3v2h58EqzST6Ouk0ckRHyugmXxR7WmVBrtK9oLslv7o0v79/jucdrVk+2u/bKc
         hELMMEtKV097If4rHuxkL2E7tujW5y5Gd2vmXNhkt4QD3Rg6QrW9tZ6RFBDGCYaelQJg
         kC5QcVn3DbQ4fWiU091kUhb8PqoLSuM5vxvYuUcut+LC0F1+kWXHudSFK1IFzl/pOrpy
         t+TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741079945; x=1741684745;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=N3AjM8ftIsOPsYgJWv0+oWMt9DGBIDRSnD7gYyAfq9k=;
        b=RLsjKb10+pStgwy/k1gsTq0kDtOzjA98MM9lv+Isa3/gHIM9RQe0+wtLO3Hqm4AQZ5
         cQrT/EnPCD64phCwPyZw5lQ7pl02jJ1aKQD32DOzr251gGOBq9wWoizllymymfW6HhgH
         oWB57pc2lJ2AYxhIN7Xd+WVfRdz9DygOW0DG8XDDUYoTJXxb5AdvpaqH+TNlu6KN6lWd
         14icLwhGXeGabW2mg2adM7eX2eUiUVKREuueolDy0c+NjQeYSIv6/CZRWlzj84tPk/5r
         p/6f/K1wW8CVubcgdJhaE1Wf6fyJLTjDeQyEcbBQQVPK2tVZHMcRPQlCUIKbr7Cw9i98
         AkZQ==
X-Gm-Message-State: AOJu0YwpWwEmZtKzBGrSw4rwQZimtzc7YvxZbAMLxL5xZwn9bO5NwiOR
	joAKq4mjtIYILyBCD7qolE+nkv8oboZtBQLQBqa3SFcXuRQReEBtiZ5pyrNqFKI=
X-Gm-Gg: ASbGncug6+9YsIKEdZEIoe0fy/KlHbue5ZrLQKD1g/IEDnIp41xwGVimmTnRnWxtQXQ
	kgSUyoo9Ssl5K7CggZx9mftFkSTfUSTsoNVuHvofv4JXflGFxIKCcWXyYgU469DmIy2SFFNqLxn
	WbSzIV1lAwc7bTuhY/wcpilkY0gMePTKj9NfOT/LGXjuR+jrpkLuiZUDHGQhlQvS8oJJj+cFIir
	7HRByRvA64aPWZ82fv/P++8+V7eOARaEyV52bopVdAd+8cNcqI6t3uNBOhszdhLm8K9k9/71W3k
	BehlUpL6Bq1kuR3THsMRI+f2drkFiSnMIUOP7nDboFsDU+YzEA==
X-Google-Smtp-Source: AGHT+IHCeXsjA/lQe9/4BN56MAYv9jtfxOWsXHEH3nafZp4Z9nl9OhJx1+LwFXEfBl63wWyGCjAnXw==
X-Received: by 2002:a05:6000:2ce:b0:38d:d9bd:18a6 with SMTP id ffacd0b85a97d-390eca07164mr12539372f8f.42.1741079945067;
        Tue, 04 Mar 2025 01:19:05 -0800 (PST)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-43bcae29b28sm23453985e9.2.2025.03.04.01.19.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Mar 2025 01:19:04 -0800 (PST)
Date: Tue, 4 Mar 2025 12:19:00 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: ceph-devel@vger.kernel.org
Subject: [bug report] ceph: Convert ceph_readdir_cache_control to store a
 folio
Message-ID: <958111ae-3534-46f7-aed0-3ccb9fadb995@stanley.mountain>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Matthew Wilcox (Oracle),

Commit baff9740bc8f ("ceph: Convert ceph_readdir_cache_control to
store a folio") from Feb 17, 2025 (linux-next), leads to the
following Smatch static checker warning:

	fs/ceph/inode.c:1873 fill_readdir_cache()
	warn: 'ctl->folio' is an error pointer or valid

fs/ceph/inode.c
    1854 static int fill_readdir_cache(struct inode *dir, struct dentry *dn,
    1855                               struct ceph_readdir_cache_control *ctl,
    1856                               struct ceph_mds_request *req)
    1857 {
    1858         struct ceph_client *cl = ceph_inode_to_client(dir);
    1859         struct ceph_inode_info *ci = ceph_inode(dir);
    1860         unsigned nsize = PAGE_SIZE / sizeof(struct dentry*);
    1861         unsigned idx = ctl->index % nsize;
    1862         pgoff_t pgoff = ctl->index / nsize;
    1863 
    1864         if (!ctl->folio || pgoff != ctl->folio->index) {
    1865                 ceph_readdir_cache_release(ctl);
    1866                 fgf_t fgf = FGP_LOCK;
    1867 
    1868                 if (idx == 0)
    1869                         fgf |= FGP_ACCESSED | FGP_CREAT;
    1870 
    1871                 ctl->folio = __filemap_get_folio(&dir->i_data, pgoff,
    1872                                 fgf, mapping_gfp_mask(&dir->i_data));
--> 1873                 if (!ctl->folio) {
    1874                         ctl->index = -1;
    1875                         return idx == 0 ? -ENOMEM : 0;

The __filemap_get_folio() never returns NULL, it returns error pointers.

    1876                 }
    1877                 /* reading/filling the cache are serialized by
    1878                  * i_rwsem, no need to use folio lock */
    1879                 folio_unlock(ctl->folio);
    1880                 ctl->dentries = kmap_local_folio(ctl->folio, 0);
    1881                 if (idx == 0)
    1882                         memset(ctl->dentries, 0, PAGE_SIZE);
    1883         }
    1884 
    1885         if (req->r_dir_release_cnt == atomic64_read(&ci->i_release_count) &&
    1886             req->r_dir_ordered_cnt == atomic64_read(&ci->i_ordered_count)) {
    1887                 doutc(cl, "dn %p idx %d\n", dn, ctl->index);
    1888                 ctl->dentries[idx] = dn;
    1889                 ctl->index++;
    1890         } else {
    1891                 doutc(cl, "disable readdir cache\n");
    1892                 ctl->index = -1;
    1893         }
    1894         return 0;
    1895 }

regards,
dan carpenter

