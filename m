Return-Path: <ceph-devel+bounces-997-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 18263889636
	for <lists+ceph-devel@lfdr.de>; Mon, 25 Mar 2024 09:47:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 499C81C2FEA6
	for <lists+ceph-devel@lfdr.de>; Mon, 25 Mar 2024 08:47:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31A211292D0;
	Mon, 25 Mar 2024 05:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="He7+N1fx"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFF14147C87
	for <ceph-devel@vger.kernel.org>; Mon, 25 Mar 2024 01:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711330130; cv=none; b=TaO12aqtuoORYGc7O4nRYKbjFUT3bhZoupKTFhUVbiGKz2lqLWBvGl9jvsjz6l7dSbYYTqF+0mj1KZtz37/EelypEi2HN/8mTUNFg6OwfavtvompduXOAgZO/h1ko1RPVMSEUp9wEI+46BaeQMhbT2C8FWWIwfPdy7o3K2GT8cU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711330130; c=relaxed/simple;
	bh=WFXE0LyhpXVE34d6fzCorzPh2exOtIPxJFRjDF9KNQs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pJJFN6ORlN16KyjysfhhF8g7sAFzD9wRb8xvlWleQIp407dS1hWYZUENOLGw12XwJ1Yn0xNRVuJcM96JAvrTfIEnGSBXbYLaGw0AwN0ZJMQM+grGlb7USxBaYifcDogpHGGOH+Avfj4r+gI07ztmICgk2/jz6Sierxa0nZ+IYkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=He7+N1fx; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711330127;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ftTLhBm1e2gJ56tO/FlETKKI9BM6pFOz9k6Ug2XyB3Y=;
	b=He7+N1fxh/lVFfGNHUU8oFIS1g5a9Mu9No5Ye8AMjdLFzmxsSe0mu9OAZfhLcPmDTz9QkE
	p+ZMYxekKyFOMjI9h+h7609DjTRxzApHXr4OIg1fZjpzZ4jU4VjCYNxSjAzlhGe8OTjB/j
	uqXjrTUXMoyw+Z4MaqdIGDZsWoBMTkE=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-350-KLfTkZkIOFyZeQXS5sfHtw-1; Sun, 24 Mar 2024 21:28:46 -0400
X-MC-Unique: KLfTkZkIOFyZeQXS5sfHtw-1
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-5d8bdadc79cso2934946a12.2
        for <ceph-devel@vger.kernel.org>; Sun, 24 Mar 2024 18:28:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711330125; x=1711934925;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ftTLhBm1e2gJ56tO/FlETKKI9BM6pFOz9k6Ug2XyB3Y=;
        b=uhrk2xGaj2TAZKeP0n6fhyGQTXInMeXhR3OEDhl2c1xjWhEkGEL5HVDOmQG7oyFvZK
         cFEFMFVmZavTFb84jf4WtiTMetjJ5BFBa+U3MPbwEei3QpUjg3tHy2IIkZDBWEsShW0E
         6iZYjFZjSkMvPyHjv/jwvO5QGdUL9KnEsCFwkEzTN5rnvdNbhN/lXlC6Cnl94d1EO/C+
         0UNpSPUQWM5c/mIsrbv1PbUeCpeq0EZS5dswx1FbneL0IcPh2gf0abX1kPxSyL/SInxM
         epQcNnF67xxejf/4axuiXA0dxzE61nOqx+Jc2/I0EWEJAsSpX3D3GbYm8FzzrEuxr0Zs
         veDQ==
X-Gm-Message-State: AOJu0YybI/7k7Rkk1Q5wYI6O9ePP410BDUppJ3NupRlsj30W2eEffyn7
	dxwWTx8EGFcOot0yXB1iIFMJT3UMwXSMXikgN0T0dhhVfgMA5arWtsYm3wpxEm9QUH7V5GgoPsl
	8pzPxdne13E87PUEfrHyDFbHJx+2B68eCEolySyhZBgVciy5B5cCMuRX9gvn4d7bfI66HiQ==
X-Received: by 2002:a17:902:fc45:b0:1dd:651d:cc47 with SMTP id me5-20020a170902fc4500b001dd651dcc47mr8387343plb.28.1711330124845;
        Sun, 24 Mar 2024 18:28:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE7DxffZ6rfU5Q6avcSf5HCRZu31rwVGtmTLzEB1UCS0aZJfYF74AQEynh80jx9s6pF8Xl/tg==
X-Received: by 2002:a17:902:fc45:b0:1dd:651d:cc47 with SMTP id me5-20020a170902fc4500b001dd651dcc47mr8387321plb.28.1711330124461;
        Sun, 24 Mar 2024 18:28:44 -0700 (PDT)
Received: from [10.72.113.22] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id b5-20020a170902d50500b001dd6e0a0c1bsm3639417plg.268.2024.03.24.18.28.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 24 Mar 2024 18:28:43 -0700 (PDT)
Message-ID: <88f42e4c-4046-4d8d-a7aa-3aad66f38cba@redhat.com>
Date: Mon, 25 Mar 2024 09:28:39 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ceph: redirty page before returning
 AOP_WRITEPAGE_ACTIVATE
Content-Language: en-US
To: NeilBrown <neilb@suse.de>, Ilya Dryomov <idryomov@gmail.com>,
 Jeff Layton <jlayton@kernel.org>
Cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <171131888022.13576.8585118457506044105@noble.neil.brown.name>
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <171131888022.13576.8585118457506044105@noble.neil.brown.name>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 3/25/24 06:21, NeilBrown wrote:
> The page has been marked clean before writepage is called.  If we don't
> redirty it before postponing the write, it might never get written.
>
> Fixes: 503d4fa6ee28 ("ceph: remove reliance on bdi congestion")
> Signed-off-by: NeilBrown <neilb@suse.de>
> ---
>   fs/ceph/addr.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index 1340d77124ae..ee9caf7916fb 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -795,8 +795,10 @@ static int ceph_writepage(struct page *page, struct writeback_control *wbc)
>   	ihold(inode);
>   
>   	if (wbc->sync_mode == WB_SYNC_NONE &&
> -	    ceph_inode_to_fs_client(inode)->write_congested)
> +	    ceph_inode_to_fs_client(inode)->write_congested) {
> +		redirty_page_for_writepage(wbc, page);
>   		return AOP_WRITEPAGE_ACTIVATE;
> +	}
>   
>   	wait_on_page_fscache(page);
>   

Good catch!

Applied to the testing branch to run the tests.

Thanks NeilBrown

- Xiubo


