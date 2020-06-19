Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D8401FFF5B
	for <lists+ceph-devel@lfdr.de>; Fri, 19 Jun 2020 02:39:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729228AbgFSAjP (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 18 Jun 2020 20:39:15 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:45520 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725912AbgFSAjO (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 18 Jun 2020 20:39:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592527153;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UqR2QvJCaHT2SWfnNy+yFE8SshDAAcfsRtRAQ0RbygE=;
        b=hWSFVa8w3oUx/0UkMj3I7a37r3/+p4LjD3tV71N3ELemQVFNQKdk5rnbAr+Ejl6N/MbrIy
        YV188HkepWn2LqAwnh8d8r38K9Rabj5n9CkfuAoR4nsyV0iEvFp5UokBLRaZ6t42GzOldo
        SCJnZddnijn7hCd3ghKyAk2VXVEV8Bg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-62-tDDHIRcIPZ6ToBlE0n2j1Q-1; Thu, 18 Jun 2020 20:39:11 -0400
X-MC-Unique: tDDHIRcIPZ6ToBlE0n2j1Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6E9F0107ACCD;
        Fri, 19 Jun 2020 00:39:10 +0000 (UTC)
Received: from [10.72.13.235] (ovpn-13-235.pek2.redhat.com [10.72.13.235])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 093D719C4F;
        Fri, 19 Jun 2020 00:39:05 +0000 (UTC)
Subject: Re: [PATCH v2 3/5] ceph: check the METRIC_COLLECT feature before
 sending metrics
To:     Jeff Layton <jlayton@kernel.org>, idryomov@gmail.com
Cc:     zyan@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
References: <1592481599-7851-1-git-send-email-xiubli@redhat.com>
 <1592481599-7851-4-git-send-email-xiubli@redhat.com>
 <00a99a4873e2bb1dbfff995c2ff49fdbe5ea5aaf.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <cd142805-9d96-61c5-c8bd-9b2cc0c4d395@redhat.com>
Date:   Fri, 19 Jun 2020 08:39:03 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <00a99a4873e2bb1dbfff995c2ff49fdbe5ea5aaf.camel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/6/18 22:43, Jeff Layton wrote:
> On Thu, 2020-06-18 at 07:59 -0400, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> Skip the MDS sessions if they don't support the metric collection,
>> or the MDSs will close the socket connections directly when it get
>> an unknown type message.
>>
>> URL: https://tracker.ceph.com/issues/43215
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/mds_client.h | 4 +++-
>>   fs/ceph/metric.c     | 8 ++++++++
>>   2 files changed, 11 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
>> index bcb3892..3c65ac1 100644
>> --- a/fs/ceph/mds_client.h
>> +++ b/fs/ceph/mds_client.h
>> @@ -28,8 +28,9 @@ enum ceph_feature_type {
>>   	CEPHFS_FEATURE_LAZY_CAP_WANTED,
>>   	CEPHFS_FEATURE_MULTI_RECONNECT,
>>   	CEPHFS_FEATURE_DELEG_INO,
>> +	CEPHFS_FEATURE_METRIC_COLLECT,
>>   
>> -	CEPHFS_FEATURE_MAX = CEPHFS_FEATURE_DELEG_INO,
>> +	CEPHFS_FEATURE_MAX = CEPHFS_FEATURE_METRIC_COLLECT,
>>   };
>>   
>>   /*
>> @@ -43,6 +44,7 @@ enum ceph_feature_type {
>>   	CEPHFS_FEATURE_LAZY_CAP_WANTED,		\
>>   	CEPHFS_FEATURE_MULTI_RECONNECT,		\
>>   	CEPHFS_FEATURE_DELEG_INO,		\
>> +	CEPHFS_FEATURE_METRIC_COLLECT,		\
>>   						\
>>   	CEPHFS_FEATURE_MAX,			\
>>   }
>> diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
>> index 27cb541..4267b46 100644
>> --- a/fs/ceph/metric.c
>> +++ b/fs/ceph/metric.c
>> @@ -127,6 +127,14 @@ static void metric_delayed_work(struct work_struct *work)
>>   			continue;
>>   		}
>>   
>> +		/*
>> +		 * Skip it if MDS doesn't support the metric collection,
>> +		 * or the MDS will close the session's socket connection
>> +		 * directly when it get this message.
>> +		 */
>> +		if (!test_bit(CEPHFS_FEATURE_METRIC_COLLECT, &s->s_features))
>> +			continue;
>> +
>>   		/* Only send the metric once in any available session */
>>   		ret = ceph_mdsc_send_metrics(mdsc, s, nr_caps);
>>   		ceph_put_mds_session(s);
> This should probably be moved ahead of, or folded into the previous
> patch to prevent a regression should someone land in between them when
> bisecting.

Yeah, make sense, let's fold it into the previous one.

Thanks.

