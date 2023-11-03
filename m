Return-Path: <ceph-devel+bounces-31-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 050BE7DFF81
	for <lists+ceph-devel@lfdr.de>; Fri,  3 Nov 2023 08:53:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9B9DC1F225DA
	for <lists+ceph-devel@lfdr.de>; Fri,  3 Nov 2023 07:53:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2769979CD;
	Fri,  3 Nov 2023 07:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Kqb3mI5O"
X-Original-To: ceph-devel@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B44D749C
	for <ceph-devel@vger.kernel.org>; Fri,  3 Nov 2023 07:53:44 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C98651A6
	for <ceph-devel@vger.kernel.org>; Fri,  3 Nov 2023 00:53:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698998018;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EZQil6l+VLukoet0D15M2wfvLz2HuF5qUGINciaEeGQ=;
	b=Kqb3mI5Om0EuwZA6fPX18bHz9DM0a6hVrs2YlDI0+bDBaP/QNNY0IAWisGtaU6P8z4BXcQ
	EZU9bbJ83ZZSgcq+UMGChN8s8OwluDedYXcZ4CblhCzmSHgbTJgsnXhV6GdYZiqrK6wmJS
	eC8u1/MlwGuBB1WVegRVKK1IHEAFkCo=
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com
 [209.85.167.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-641-rqpD8aDnPoGAfvs7P9_uVQ-1; Fri, 03 Nov 2023 03:53:37 -0400
X-MC-Unique: rqpD8aDnPoGAfvs7P9_uVQ-1
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-3b3fb625e3bso2449206b6e.3
        for <ceph-devel@vger.kernel.org>; Fri, 03 Nov 2023 00:53:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698998017; x=1699602817;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EZQil6l+VLukoet0D15M2wfvLz2HuF5qUGINciaEeGQ=;
        b=CeX8Cyq5bsGq35IgYcurfvqBsbL12p2/aWu9oXkN8Am1f/iSVpESokouc8lsTTNEaO
         HdmWJRNCOAb3PdH6EkJt9hwQdJN3jzWKT8xTGlc51h9nJP8QGzmwkgI4a230b+A7alGs
         MbptXVNHcEezjNkUNkHr7Z1W6igDcfU2Qswh7jG5mGo/HeRomk+lvYg4Es3gUJ97lCiF
         KyQMVCXjQudmK/Nr69c+2XQ/xryVoFv2N3bkByTJ1S6RfsDcaNseQOS940v3YwCwCIcK
         LQgJ6zRB91CgszQASwgRuyPqjCUCyjZHHjXsYSqty/1mY7Hp6x1Z82/oBPcTPWtwh/qU
         H/Pw==
X-Gm-Message-State: AOJu0Yw1m5xkxf7ePxCoK15LCidpuAuhAe2346Ix9IhEz78DXbtfagQ4
	pppAQD2078w7t/T6SCyDVo7ORPGnilFi5wPXPO/0925FskKkSrp4q0pG/MK2nVgdooab97I+iIr
	XGIBaT0c+qmVnsLaqAi8Tbg==
X-Received: by 2002:a05:6808:200e:b0:3a4:2204:e9e6 with SMTP id q14-20020a056808200e00b003a42204e9e6mr24767687oiw.21.1698998016843;
        Fri, 03 Nov 2023 00:53:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFrbOKqJ0qzhVWDAI4b8nhiG4BRZF7CzaAryYsi86jIRQAJk2+QO1KL3XCL/yT8fPK8TZUmyA==
X-Received: by 2002:a05:6808:200e:b0:3a4:2204:e9e6 with SMTP id q14-20020a056808200e00b003a42204e9e6mr24767680oiw.21.1698998016605;
        Fri, 03 Nov 2023 00:53:36 -0700 (PDT)
Received: from [10.72.112.124] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id y36-20020a056a00182400b0068790c41ca2sm886892pfa.27.2023.11.03.00.53.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Nov 2023 00:53:36 -0700 (PDT)
Message-ID: <184d7c48-42de-e602-e394-3c0b2cbeb0b7@redhat.com>
Date: Fri, 3 Nov 2023 15:53:33 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH] ceph: reinitialize mds feature bit even when session in
 open
Content-Language: en-US
To: Venky Shankar <vshankar@redhat.com>
Cc: mchangir@redhat.com, ceph-devel@vger.kernel.org
References: <20231103064027.316296-1-vshankar@redhat.com>
 <CACPzV1mkHsWmUy60MxZg0VA-ewm=KW62ODT019jDtSL5EzErNw@mail.gmail.com>
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <CACPzV1mkHsWmUy60MxZg0VA-ewm=KW62ODT019jDtSL5EzErNw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 11/3/23 14:43, Venky Shankar wrote:
> On Fri, Nov 3, 2023 at 12:10 PM Venky Shankar <vshankar@redhat.com> wrote:
>> Following along the same lines as per the user-space fix. Right
>> now this isn't really an issue with the ceph kernel driver because
>> of the feature bit laginess, however, that can change over time
>> (when the new snaprealm info type is ported to the kernel driver)
>> and depending on the MDS version that's being upgraded can cause
>> message decoding issues - so, fix that early on.
>>
>> URL: Fixes: http://tracker.ceph.com/issues/63188
>> Signed-off-by: Venky Shankar <vshankar@redhat.com>
>> ---
>>   fs/ceph/mds_client.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>> index a7bffb030036..48d75e17115c 100644
>> --- a/fs/ceph/mds_client.c
>> +++ b/fs/ceph/mds_client.c
>> @@ -4192,6 +4192,7 @@ static void handle_session(struct ceph_mds_session *session,
>>                  if (session->s_state == CEPH_MDS_SESSION_OPEN) {
>>                          pr_notice_client(cl, "mds%d is already opened\n",
>>                                           session->s_mds);
>> +                       session->s_features = features;
> Xiubo, the metrics stuff isn't done here (as it's done in the else
> case). That's probably required I guess??

That should be okay, but it harmless to do it here.

So let's just fix it by:

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 41be58baaa57..de3c6b6cbd07 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -4263,17 +4263,16 @@ static void handle_session(struct 
ceph_mds_session *session,
                         pr_info_client(cl, "mds%d reconnect success\n",
                                        session->s_mds);

-               if (session->s_state == CEPH_MDS_SESSION_OPEN) {
+               if (session->s_state == CEPH_MDS_SESSION_OPEN)
                         pr_notice_client(cl, "mds%d is already opened\n",
                                          session->s_mds);
-               } else {
+               else
                         session->s_state = CEPH_MDS_SESSION_OPEN;
-                       session->s_features = features;
-                       renewed_caps(mdsc, session, 0);
-                       if (test_bit(CEPHFS_FEATURE_METRIC_COLLECT,
-                                    &session->s_features))
- metric_schedule_delayed(&mdsc->metric);
-               }
+               session->s_features = features;
+               renewed_caps(mdsc, session, 0);
+               if (test_bit(CEPHFS_FEATURE_METRIC_COLLECT,
+                            &session->s_features))
+ metric_schedule_delayed(&mdsc->metric);

                 /*
                  * The connection maybe broken and the session in client

Thanks

- Xiubo


>
>>                  } else {
>>                          session->s_state = CEPH_MDS_SESSION_OPEN;
>>                          session->s_features = features;
>> --
>> 2.39.3
>>
>


