Return-Path: <ceph-devel+bounces-960-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 587AA87459A
	for <lists+ceph-devel@lfdr.de>; Thu,  7 Mar 2024 02:19:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7920F1C21E55
	for <lists+ceph-devel@lfdr.de>; Thu,  7 Mar 2024 01:19:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF1BB4A33;
	Thu,  7 Mar 2024 01:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FXPzicDx"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDFFD393
	for <ceph-devel@vger.kernel.org>; Thu,  7 Mar 2024 01:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709774354; cv=none; b=cYasXbexr2lEGZ3CV3rSw9Q9XthHUbE1zjp9yM9GsX6bmC6mkCK3u0/x5heVIhr3LcL3VQLJfVL8QmnPazipCFsnzZLaW4hH6o89DLKbIxODWyzXoeTZ0gtNR8EfMGYir+4XoKee9JFaJkKIqfKpL4dUp8wBClVe5pwhbcHP9jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709774354; c=relaxed/simple;
	bh=J+MFSfHS/L6cqIT2sdP3rSvxlrOMeUxWnqOc3q9HDwE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=l6BlC3QuFjxkeh+7dvCr+YpQ1t/lLCD3obu0enmZy5xwKZaMKs57fTpLS4MVjsHcLgY8l85LTg0FgXZ7DNZbjHUAqgZZVMGG3W8n2rWRwVEVhubEUUMWTonYLHNPPZUYn6u6aweEFQmRf9Du1fNoq1qA8ZLLu/RAypqFD3FfrWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FXPzicDx; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709774351;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IWlwZvSAOW82Go5PsWwdUytC/995m6prLipayyg+JPc=;
	b=FXPzicDx98J422FrDh/iEoeJfXW4Zg0LQJPkqbKTMKSDGCEgBsiQLeXRb2EkFPCXhE36Ih
	1PXpVk4er+nSjWcvtUxl8+k1LD64KcQq/FXYjQV20eUS/eXSXK1WadkLvldsnUtPWkmKkk
	0DsgK4PgM5wSgxFbNXy9BTtJtR+m9Yk=
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com
 [209.85.167.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-474-GbRIx9DfMs6v_bbuYAY5ow-1; Wed, 06 Mar 2024 20:19:09 -0500
X-MC-Unique: GbRIx9DfMs6v_bbuYAY5ow-1
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-3c225dcfcb6so220674b6e.2
        for <ceph-devel@vger.kernel.org>; Wed, 06 Mar 2024 17:19:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709774348; x=1710379148;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IWlwZvSAOW82Go5PsWwdUytC/995m6prLipayyg+JPc=;
        b=QY8MqOWhDfZIng2zDDBtkeb1otWs3zqWdJdEwbkQ3qfwjXpBdqtN6uXDXJXMZKWyKb
         RYqK2YG9ehEdWN2ymQ4LmcFdhWxhlPm4gBdNtUqUtzTqdppHCjosyWrvktjGT6/Oh3za
         TC3oIDfap2K0jWNT4AW3V+e9WBmiYweItQwnBHhQTAXItMfgDXtnmhy+AGXevIx/JGdO
         KR8CdBH5g3Ixifw/XtTDyTCxYtGE3zM4AU8AXPCX/tq8ieUVWQgeOpj+L1BYnrHTJk6W
         2QZEqMs/rUxk2489RgNUEQ2hfmU+YFJvhHSSTT7UqXk93Ov1LrTe4C4ttAUhE6lqtWWy
         7RQw==
X-Gm-Message-State: AOJu0YwEHx+g6fRTI+H2YLCfqRVdoaZ3h17TAJm0Fu5pKd6myxwg6WRB
	sMj2i74EcC+cxI9CvZGtfx5W12NgtKmUant4tYgFAk5XofZYSjMp8Pl3v4YGLgtzZ7HEp9FJbOR
	Gw5imcrx4zzEwNCDPBxQp1i69oU6mQaxHOcNHjK8IMiOMZfs2IEM25v9hKrE=
X-Received: by 2002:a05:6808:614c:b0:3c1:f61c:a1d with SMTP id dl12-20020a056808614c00b003c1f61c0a1dmr6609240oib.47.1709774348403;
        Wed, 06 Mar 2024 17:19:08 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF2V8Ng4NfvyMnsWM+S3C1pxWbgjK342jgNSNDTHGcw2YlpiSAkOWxtK49VJEBykt7FEM6cjg==
X-Received: by 2002:a05:6808:614c:b0:3c1:f61c:a1d with SMTP id dl12-20020a056808614c00b003c1f61c0a1dmr6609232oib.47.1709774348161;
        Wed, 06 Mar 2024 17:19:08 -0800 (PST)
Received: from [10.72.113.7] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id c6-20020a056a000ac600b006e627f33178sm5400913pfl.213.2024.03.06.17.19.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Mar 2024 17:19:07 -0800 (PST)
Message-ID: <db2246fb-6938-48dd-8347-be64efa94720@redhat.com>
Date: Thu, 7 Mar 2024 09:19:03 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] libceph: init the cursor when preparing the sparse
 read
Content-Language: en-US
To: Luis Henriques <lhenriques@suse.de>
Cc: ceph-devel@vger.kernel.org, idryomov@gmail.com, jlayton@kernel.org,
 vshankar@redhat.com, mchangir@redhat.com, stable@vger.kernel.org
References: <20240306010544.182527-1-xiubli@redhat.com>
 <87msrbr4b3.fsf@suse.de>
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <87msrbr4b3.fsf@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 3/6/24 19:24, Luis Henriques wrote:
> xiubli@redhat.com writes:
>
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> The osd code has remove cursor initilizing code and this will make
>> the sparse read state into a infinite loop. We should initialize
>> the cursor just before each sparse-read in messnger v2.
>>
>> Cc: stable@vger.kernel.org
>> URL: https://tracker.ceph.com/issues/64607
>> Fixes: 8e46a2d068c9 ("libceph: just wait for more data to be available on the socket")
>> Reported-by: Luis Henriques <lhenriques@suse.de>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>
>> V2:
>> - Just removed the unnecessary 'sparse_read_total' check.
>>
> Thanks a lot for the quick fix, Xiubo.  FWIW:
>
> Tested-by: Luis Henriques <lhenriques@suse.de>
>
> Note that I still see this test failing occasionally, but I haven't had
> time to help debugging it.  And that's a different issue, of course.  TBH
> I don't remember if this test ever used to reliably pass.  Here's the
> output diff shown by fstests in case you're not able to reproduce it:
>
> @@ -65,7 +65,7 @@
>   # Getting encryption key status
>   Present (user_count=1, added_by_self)
>   # Removing encryption key
> -Removed encryption key with identifier 69b2f6edeee720cce0577937eb8a6751
> +Removed encryption key with identifier 69b2f6edeee720cce0577937eb8a6751, but files still busy
>   # Getting encryption key status
>   Absent
>   # Verifying that the encrypted directory was "locked"

Thanks Luis.

This is a different issue as I remembered I have seen this before in msgr1.

Thanks

- Xiubo

> Cheers,


