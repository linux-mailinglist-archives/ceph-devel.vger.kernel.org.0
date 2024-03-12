Return-Path: <ceph-devel+bounces-970-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E628878BC2
	for <lists+ceph-devel@lfdr.de>; Tue, 12 Mar 2024 01:03:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AC3D81C211FB
	for <lists+ceph-devel@lfdr.de>; Tue, 12 Mar 2024 00:03:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F6658472;
	Tue, 12 Mar 2024 00:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CdIHrF+J"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D7FF79CC
	for <ceph-devel@vger.kernel.org>; Tue, 12 Mar 2024 00:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710201806; cv=none; b=tdD+gu/IGDlI0qy0Va+56dwYkRlTvb2F03+J/md0yeXmqHqrsGRHCggi8zY46X+Di+uXtCOY/AGTmoXonEpTz+hjLilaSeIP8LPiOrB2IlbGQeK68S5xP2msP1+R77rCTZ/fgMMzr8EfeBUV+2lU+tfOXt+3uUh6xpAt4XywVjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710201806; c=relaxed/simple;
	bh=vEVvDZ3C501jyXorksPcnb24ViyC8qmPoISEg/Xnado=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rSuV3d9gRG3oGN4PFH+CrOoK92gCYW0Gl8bUVRjV1ytLpYNAaCtV3KmBC0lZxUCODieNIxC7E0sgb/XehCbqw2WlfzZ4vUX4zssex7nALx2hSytBvZnpgbRHSsLPtgOyZISyulKN+GNHzGwpH52mtCWXa6JClY9rK24m873OSIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CdIHrF+J; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710201803;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uaNIBBc+JitDpKvmzNnQpcdqvKiIGo31c+IvsHwtQqk=;
	b=CdIHrF+JbqD1+nrOBBnGVh1dzpwJCE8ZcljaVC+15EMMfj1RUL3otmTkXYdQ6P6epmzGuE
	Ib8s5rULiYQP2ixDEaUPtnsuwfzP/Ciux13A2ag7C81U64TmDMPiE7mR9dfY/mVnHSvWzN
	eO2bbe9KcnAada1gAUjDrZBll66Cg2Q=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-589-lH7gRTELPKmheZzX83Srbg-1; Mon, 11 Mar 2024 20:03:22 -0400
X-MC-Unique: lH7gRTELPKmheZzX83Srbg-1
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-5cf35636346so3516292a12.3
        for <ceph-devel@vger.kernel.org>; Mon, 11 Mar 2024 17:03:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710201800; x=1710806600;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uaNIBBc+JitDpKvmzNnQpcdqvKiIGo31c+IvsHwtQqk=;
        b=HamFsE8zzDa8xLsGgOZDCx5xYJLIJpHatiOZkdC2TU0KWczjTgy7CpoIyMvrhWonMB
         ovFA+MiQ7puetv/RjpthlQC8aMBw0yLlKf6kvxI7molmklBuP3yqyay5Nn7EtBuwgz/n
         hKcHMSz99g/lQi2/pQEwE4Y/eEPuK2r32mWfCA1DJmbe77CSCcLl22bctiniEF1b+CFr
         RZy49ruHZoG11Wg/9yfA4+cq1uWA+/c50yYeyDLD4hD+wOKqJ6ht2NehK4ErZddfpDNa
         eeRu4gUS6aVoLFprYRYm2mUZ7deXWWErpKWjdhSj10vWHT4r/tDMQmOl34akDYq5fT7v
         0rFg==
X-Gm-Message-State: AOJu0Yy9LBN0CkzT0cU8LvY1vYDYtH/2x6JmzGfWVvTF7XBD23er9iJH
	uCacTpNXfVcjTntCOWPKMpJxxNCd1y6vy+rR5FaEbDeUGlMjGRC32vNkxiBrluIWQ4XyKie2WdS
	9XH2gXjZC00qpOy47TZeDbDImGPtXv/fDjtS5zsPvpNp3H4d81I0K2j564Aw2cKT7xGdpuQ==
X-Received: by 2002:a05:6a21:9211:b0:1a1:6afb:8e3 with SMTP id tl17-20020a056a21921100b001a16afb08e3mr2478948pzb.19.1710201800674;
        Mon, 11 Mar 2024 17:03:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHNUjfH6vLuGzDxhiXZO6cxgcF+UAIkhYy1Fce4EoC5OoLAriGqfGAPOuY/WukZLS11muaWtA==
X-Received: by 2002:a05:6a21:9211:b0:1a1:6afb:8e3 with SMTP id tl17-20020a056a21921100b001a16afb08e3mr2478921pzb.19.1710201800287;
        Mon, 11 Mar 2024 17:03:20 -0700 (PDT)
Received: from [10.72.112.38] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id s63-20020a17090a69c500b0029b9f35648asm5204053pjj.24.2024.03.11.17.03.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Mar 2024 17:03:19 -0700 (PDT)
Message-ID: <629e5c13-a9ca-486e-88f4-d7f0f0cf8b96@redhat.com>
Date: Tue, 12 Mar 2024 08:03:15 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/6] ceph: check the cephx mds auth access in client
 side
Content-Language: en-US
To: Venky Shankar <vshankar@redhat.com>
Cc: ceph-devel@vger.kernel.org, idryomov@gmail.com, jlayton@kernel.org,
 mchangir@redhat.com
References: <20240227072705.593676-1-xiubli@redhat.com>
 <CACPzV1nBgM8xxfVY04M4AeTCyE3Lofw-oCnfkeo=cJEX3vrkgA@mail.gmail.com>
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <CACPzV1nBgM8xxfVY04M4AeTCyE3Lofw-oCnfkeo=cJEX3vrkgA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 3/11/24 13:42, Venky Shankar wrote:
> On Tue, Feb 27, 2024 at 1:04 PM <xiubli@redhat.com> wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> The code are refered to the userspace libcephfs:
>> https://github.com/ceph/ceph/pull/48027.
>>
>>
>> V4:
>> - Fix https://tracker.ceph.com/issues/64172
>> - Improve the comments and code in ceph_mds_auth_match() to make it
>>    to be more readable.
>>
>> V3:
>> - Fix https://tracker.ceph.com/issues/63141.
>>
>> V2:
>> - Fix memleak for built 'path'.
>>
>>
>> Xiubo Li (6):
>>    ceph: save the cap_auths in client when session being opened
>>    ceph: add ceph_mds_check_access() helper support
>>    ceph: check the cephx mds auth access for setattr
>>    ceph: check the cephx mds auth access for open
>>    ceph: check the cephx mds auth access for async dirop
>>    ceph: add CEPHFS_FEATURE_MDS_AUTH_CAPS_CHECK feature bit
>>
>>   fs/ceph/dir.c        |  28 +++++
>>   fs/ceph/file.c       |  66 ++++++++++-
>>   fs/ceph/inode.c      |  46 ++++++--
>>   fs/ceph/mds_client.c | 270 ++++++++++++++++++++++++++++++++++++++++++-
>>   fs/ceph/mds_client.h |  28 ++++-
>>   5 files changed, 425 insertions(+), 13 deletions(-)
>>
>> --
>> 2.43.0
>>
> Tested-by: Venky Shankar <vshankar@redhat.com>
>
Thanks Venky ！


