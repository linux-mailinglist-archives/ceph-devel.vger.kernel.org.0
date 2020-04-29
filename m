Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EF311BD8AC
	for <lists+ceph-devel@lfdr.de>; Wed, 29 Apr 2020 11:46:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726511AbgD2JqK (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 29 Apr 2020 05:46:10 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:45270 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726345AbgD2JqK (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 29 Apr 2020 05:46:10 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03T9VoBi008262;
        Wed, 29 Apr 2020 05:46:08 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30mh34fjjr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Apr 2020 05:46:08 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 03T9jJh4048845;
        Wed, 29 Apr 2020 05:46:07 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30mh34fjj1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Apr 2020 05:46:07 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03T9dhUs023145;
        Wed, 29 Apr 2020 09:46:06 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 30mcu5r3tk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Apr 2020 09:46:05 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03T9k3db459134
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Apr 2020 09:46:03 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8F8E5A406D;
        Wed, 29 Apr 2020 09:46:03 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4C356A4051;
        Wed, 29 Apr 2020 09:46:03 +0000 (GMT)
Received: from oc4278210638.ibm.com (unknown [9.145.84.48])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 29 Apr 2020 09:46:03 +0000 (GMT)
Subject: Re: [PATCH] ceph: fix up endian bug in managing feature bits
To:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
Cc:     Ulrich.Weigand@de.ibm.com, Tuan.Hoang1@ibm.com,
        "Yan, Zheng" <ukernel@gmail.com>
References: <1588023986-23672-1-git-send-email-edward6@linux.ibm.com>
 <f36451800e4656f99483f4d47487a40ea5f942cd.camel@kernel.org>
From:   Eduard Shishkin <edward6@linux.ibm.com>
Message-ID: <d322ad5e-8409-7e5e-8d16-a2706223f26f@linux.ibm.com>
Date:   Wed, 29 Apr 2020 11:46:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <f36451800e4656f99483f4d47487a40ea5f942cd.camel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-29_03:2020-04-28,2020-04-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 malwarescore=0 mlxlogscore=999 priorityscore=1501
 phishscore=0 suspectscore=0 clxscore=1011 impostorscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004290076
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 4/28/20 2:23 PM, Jeff Layton wrote:
> On Mon, 2020-04-27 at 23:46 +0200, edward6@linux.ibm.com wrote:
>> From: Eduard Shishkin <edward6@linux.ibm.com>
>>
>> In the function handle_session() variable @features always
>> contains little endian order of bytes. Just because the feature
>> bits are packed bytewise from left to right in
>> encode_supported_features().
>>
>> However, test_bit(), called to check features availability, assumes
>> the host order of bytes in that variable. This leads to problems on
>> big endian architectures. Specifically it is impossible to mount
>> ceph volume on s390.
>>
>> This patch adds conversion from little endian to the host order
>> of bytes, thus fixing the problem.
>>
>> Signed-off-by: Eduard Shishkin <edward6@linux.ibm.com>
>> ---
>>   fs/ceph/mds_client.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>> index 486f91f..190598d 100644
>> --- a/fs/ceph/mds_client.c
>> +++ b/fs/ceph/mds_client.c
>> @@ -3252,7 +3252,7 @@ static void handle_session(struct ceph_mds_session *session,
>>   	struct ceph_mds_session_head *h;
>>   	u32 op;
>>   	u64 seq;
>> -	unsigned long features = 0;
>> +	__le64 features = 0;
>>   	int wake = 0;
>>   	bool blacklisted = false;
>>   
>> @@ -3301,7 +3301,7 @@ static void handle_session(struct ceph_mds_session *session,
>>   		if (session->s_state == CEPH_MDS_SESSION_RECONNECTING)
>>   			pr_info("mds%d reconnect success\n", session->s_mds);
>>   		session->s_state = CEPH_MDS_SESSION_OPEN;
>> -		session->s_features = features;
>> +		session->s_features = le64_to_cpu(features);
>>   		renewed_caps(mdsc, session, 0);
>>   		wake = 1;
>>   		if (mdsc->stopping)
> 
> (cc'ing Zheng since he did the original patches here)
> 
> Thanks Eduard. The problem is real, but I think we can just do the
> conversion during the decode.
> 
> The feature mask words sent by the MDS are 64 bits, so if it's smaller
> we can assume that it's malformed. So, I don't think we need to handle
> the case where it's smaller than 8 bytes.
> 
> How about this patch instead?


Hi Jeff,

This also works. Please, apply.

Thanks,
Eduard.

> 
> --------------------------8<-----------------------------
> 
> ceph: fix endianness bug when handling MDS session feature bits
> 
> Eduard reported a problem mounting cephfs on s390 arch. The feature
> mask sent by the MDS is little-endian, so we need to convert it
> before storing and testing against it.
> 
> Reported-by: Eduard Shishkin <edward6@linux.ibm.com>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>   fs/ceph/mds_client.c | 8 +++-----
>   1 file changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index a8a5b98148ec..6c283c52d401 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -3260,8 +3260,7 @@ static void handle_session(struct ceph_mds_session *session,
>   	void *end = p + msg->front.iov_len;
>   	struct ceph_mds_session_head *h;
>   	u32 op;
> -	u64 seq;
> -	unsigned long features = 0;
> +	u64 seq, features = 0;
>   	int wake = 0;
>   	bool blacklisted = false;
>   
> @@ -3280,9 +3279,8 @@ static void handle_session(struct ceph_mds_session *session,
>   			goto bad;
>   		/* version >= 3, feature bits */
>   		ceph_decode_32_safe(&p, end, len, bad);
> -		ceph_decode_need(&p, end, len, bad);
> -		memcpy(&features, p, min_t(size_t, len, sizeof(features)));
> -		p += len;
> +		ceph_decode_64_safe(&p, end, features, bad);
> +		p += len - sizeof(features);
>   	}
>   
>   	mutex_lock(&mdsc->mutex);
> 
