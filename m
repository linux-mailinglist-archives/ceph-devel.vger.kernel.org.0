Return-Path: <ceph-devel+bounces-1697-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B8D8D956708
	for <lists+ceph-devel@lfdr.de>; Mon, 19 Aug 2024 11:32:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 74E57283290
	for <lists+ceph-devel@lfdr.de>; Mon, 19 Aug 2024 09:32:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC91615D5CE;
	Mon, 19 Aug 2024 09:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vgx6H6Wi"
X-Original-To: ceph-devel@vger.kernel.org
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36F8F143C63
	for <ceph-devel@vger.kernel.org>; Mon, 19 Aug 2024 09:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724059857; cv=none; b=L7SQfgBVvgJRxbnpIHzOnghZ1g/LPWmtPcnBym14Bh6YOxoVTf/ZxfXXkAJJYRuf4WQQ6Av+UEgWmWuRz0jWQpIfVfG2ou48oPOeE6xqtSx08kjAAlRvweF14DUA4gEjUr+r4sySg6bRXp2SCKLsnTYjy1FftdB6Q3I701/ia4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724059857; c=relaxed/simple;
	bh=WVnAg0aSENmZdYua8a4kGZQXMaI8lCPWVJJeL6qCIJ0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=UH7pDZ+6SBo6RIjMD8EGV3p4OACZoX6fbqtllhw2cHnK6II/c7avdhV0j6lWU0WhpRr7gvFeP/t7APIJw0Tw9QWWfiqC2LRIGcwf7UWBwnDQTtVGTnmGNL4mw7QcSpNrklSfUwHaSi0Re+nMuiBWJ99XbEindtxWwIs80fZnES0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vgx6H6Wi; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724059852;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NCJljEek1YluucbgZjTdUZseDeRXrEM/o1cJ6h1ab2E=;
	b=vgx6H6WiFa/LZsnBL+HzLJKqDZ04NaMgRYfktK3zfX2AkhTyaLNv36Cxw9x+Es6Up15Vld
	FBq/unuWq93H1oaq7A4eiQAawLrU1AiM2xzUuRaKenR5EkueSTLXifWK1FcAptl1gJ5hzW
	GalODQMGGIKyYche43Y2j54PujRwAqc=
From: Luis Henriques <luis.henriques@linux.dev>
To: Xiubo Li <xiubli@redhat.com>
Cc: Ilya Dryomov <idryomov@gmail.com>,  Milind Changire
 <mchangir@redhat.com>,  ceph-devel@vger.kernel.org,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ceph: fix memory in MDS client cap_auths
In-Reply-To: <b8c6e357-29f2-4da2-ab57-7035627b0bd2@redhat.com> (Xiubo Li's
	message of "Mon, 19 Aug 2024 09:06:45 +0800")
References: <20240814101750.13293-1-luis.henriques@linux.dev>
	<b8c6e357-29f2-4da2-ab57-7035627b0bd2@redhat.com>
Date: Mon, 19 Aug 2024 10:30:49 +0100
Message-ID: <87frr0svue.fsf@linux.dev>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT

On Mon, Aug 19 2024, Xiubo Li wrote:

> Hi Luis,
>
> Good catch!
>
> On 8/14/24 18:17, Luis Henriques (SUSE) wrote:
>> The cap_auths that are allocated during an MDS session opening are never
>> released, causing a memory leak detected by kmemleak.  Fix this by freei=
ng
>> the memory allocated when shutting down the mds client.
>>
>> Fixes: 1d17de9534cb ("ceph: save cap_auths in MDS client when session is=
 opened")
>> Signed-off-by: Luis Henriques (SUSE) <luis.henriques@linux.dev>
>> ---
>>   fs/ceph/mds_client.c | 14 ++++++++++++++
>>   1 file changed, 14 insertions(+)
>>
>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>> index 276e34ab3e2c..d798d0a5b2b1 100644
>> --- a/fs/ceph/mds_client.c
>> +++ b/fs/ceph/mds_client.c
>> @@ -6015,6 +6015,20 @@ static void ceph_mdsc_stop(struct ceph_mds_client=
 *mdsc)
>>   		ceph_mdsmap_destroy(mdsc->mdsmap);
>>   	kfree(mdsc->sessions);
>>   	ceph_caps_finalize(mdsc);
>> +
>> +	if (mdsc->s_cap_auths) {
>> +		int i;
>> +
>> +		mutex_lock(&mdsc->mutex);
>
> BTW, is the lock really needed here ?
>
> IMO it should be safe to remove it because once here the sb has already b=
een
> killed and the 'mdsc->stopping' will help guarantee that there won't be a=
ny
> other thread will access to 'mdsc', Isn't it ?

Ah, yes, good point.  Thanks, I'll send v2 shortly.

Cheers,
--=20
Lu=C3=ADs


> Else we need to do the lock from the beginning of this function.
>
> Thanks
>
> - Xiubo
>
>> +		for (i =3D 0; i < mdsc->s_cap_auths_num; i++) {
>> +			kfree(mdsc->s_cap_auths[i].match.gids);
>> +			kfree(mdsc->s_cap_auths[i].match.path);
>> +			kfree(mdsc->s_cap_auths[i].match.fs_name);
>> +		}
>> +		kfree(mdsc->s_cap_auths);
>> +		mutex_unlock(&mdsc->mutex);
>> +	}
>> +
>>   	ceph_pool_perm_destroy(mdsc);
>>   }
>>=20=20=20
>


