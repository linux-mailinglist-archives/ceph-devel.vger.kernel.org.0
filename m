Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CF17463241
	for <lists+ceph-devel@lfdr.de>; Tue, 30 Nov 2021 12:22:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238857AbhK3LZ7 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 30 Nov 2021 06:25:59 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:44267 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236283AbhK3LZ7 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 30 Nov 2021 06:25:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638271359;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XH6I+p4bHQGSgdBgS3fC7d/waajnef61crX4Ntn5Qkg=;
        b=cXDiN1MPGVmhisZQEtkKKaO6CE7KagDCGKkzlKzzdxLGncjxfiAJ83UviFhzu3uAZDUhqk
        Urvg9tuIODjoR7MF00kntFtinl9S7ESo0jmaiTy8YicPS6rJWqLmyu7sL4N4Q6vg6mNnE9
        fvWPiwwJd16Dg0bL4rM0WPiCesx8d8E=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-375-wN_eEtJ8O2WImx-D-7yXCw-1; Tue, 30 Nov 2021 06:22:37 -0500
X-MC-Unique: wN_eEtJ8O2WImx-D-7yXCw-1
Received: by mail-pf1-f198.google.com with SMTP id i26-20020aa7909a000000b004a4c417bfa8so12635580pfa.23
        for <ceph-devel@vger.kernel.org>; Tue, 30 Nov 2021 03:22:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=XH6I+p4bHQGSgdBgS3fC7d/waajnef61crX4Ntn5Qkg=;
        b=eQ28jxsWy/HDnF6yLT6uDKHvgVb/4PFTpbVVI3CgrDYDe4bqmc20Za2F+iUDk3LUkp
         s3QLE7HAvRMh0PSm/yl76Si5c/jhZQo3qAzJl1P9xa7TxZpD0lBTFKsJF4hoO8l3vTqD
         ag5L9/nW4KErbGnEphQ35a3kQ4EPylAW+9USpXRKNcyJWaqcz0Fb5/voQlCnC1BO+5VP
         Voe0JTe1BEgF+w/nt7kK9xVPQWUYa6vsFKuasLMQKwHUQqUvF/Kztikt+sei+51EWhgR
         uZRReGYGa3O30aX7yFwHbBNMqe3vMfieW9KNCMqku+/z8cSffRy7R2RKS24Zt+CCw2o8
         lMMg==
X-Gm-Message-State: AOAM53383o2DFeBW1/WZ1p2ittyMq9KzxqpfVeruLHnHothtbh7UCiUn
        iTJ/K8jOdqANYuJMOItoZHFOoqGpc0chMQ70byoj3luEguEpRDlsvak7aJjmqSGHTvsQ49n+euk
        aVle3Eozo+SWxkmg/KeyiOet9V26fM1mMvkzjcLbwe9kyI2vLxHwgowEJHi+k2xDkAjAyvWU=
X-Received: by 2002:a17:902:768b:b0:144:e570:c7d2 with SMTP id m11-20020a170902768b00b00144e570c7d2mr66663310pll.86.1638271355888;
        Tue, 30 Nov 2021 03:22:35 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyjSMEqaH6r4hPG6Vw1ihiG1BYq1CfbwLR2LwIhKWYMd6sAZckikkI1MBpqfTslOWJaqiy4QQ==
X-Received: by 2002:a17:902:768b:b0:144:e570:c7d2 with SMTP id m11-20020a170902768b00b00144e570c7d2mr66663272pll.86.1638271355420;
        Tue, 30 Nov 2021 03:22:35 -0800 (PST)
Received: from [10.72.12.65] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id j6sm20837646pfu.205.2021.11.30.03.22.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Nov 2021 03:22:34 -0800 (PST)
Subject: Re: [bug report] ceph: encode inodes' parent/d_name in cap reconnect
 message
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        "Yan, Zheng" <ukernel@gmail.com>
Cc:     ceph-devel@vger.kernel.org
References: <20211130103947.GA5827@kili>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <3256cb77-e57e-61e5-ec76-639a71a6fd3f@redhat.com>
Date:   Tue, 30 Nov 2021 19:22:30 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20211130103947.GA5827@kili>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Dan,

The email is not correct. And I have post one patch to fix it.

Thanks


On 11/30/21 6:39 PM, Dan Carpenter wrote:
> Hello Yan, Zheng,
>
> The patch a33f6432b3a6: "ceph: encode inodes' parent/d_name in cap
> reconnect message" from Aug 11, 2020, leads to the following Smatch
> static checker warning:
>
> 	fs/ceph/mds_client.c:3848 reconnect_caps_cb()
> 	error: uninitialized symbol 'pathlen'.
>
> fs/ceph/mds_client.c
>      3674 static int reconnect_caps_cb(struct inode *inode, struct ceph_cap *cap,
>      3675                           void *arg)
>      3676 {
>      3677         union {
>      3678                 struct ceph_mds_cap_reconnect v2;
>      3679                 struct ceph_mds_cap_reconnect_v1 v1;
>      3680         } rec;
>      3681         struct ceph_inode_info *ci = cap->ci;
>      3682         struct ceph_reconnect_state *recon_state = arg;
>      3683         struct ceph_pagelist *pagelist = recon_state->pagelist;
>      3684         struct dentry *dentry;
>      3685         char *path;
>      3686         int pathlen, err;
>      3687         u64 pathbase;
>      3688         u64 snap_follows;
>      3689
>      3690         dout(" adding %p ino %llx.%llx cap %p %lld %s\n",
>      3691              inode, ceph_vinop(inode), cap, cap->cap_id,
>      3692              ceph_cap_string(cap->issued));
>      3693
>      3694         dentry = d_find_primary(inode);
>      3695         if (dentry) {
>      3696                 /* set pathbase to parent dir when msg_version >= 2 */
>      3697                 path = ceph_mdsc_build_path(dentry, &pathlen, &pathbase,
>      3698                                             recon_state->msg_version >= 2);
>      3699                 dput(dentry);
>      3700                 if (IS_ERR(path)) {
>      3701                         err = PTR_ERR(path);
>      3702                         goto out_err;
>                                   ^^^^^^^^^^^^^
> "pathlen" is uninitialized on this goto.  It doesn't cause a bug.  It
> just looks weird.
>
>      3703                 }
>      3704         } else {
>      3705                 path = NULL;
>      3706                 pathlen = 0;
>      3707                 pathbase = 0;
>      3708         }
>      3709
>      3710         spin_lock(&ci->i_ceph_lock);
>      3711         cap->seq = 0;        /* reset cap seq */
>      3712         cap->issue_seq = 0;  /* and issue_seq */
>      3713         cap->mseq = 0;       /* and migrate_seq */
>      3714         cap->cap_gen = atomic_read(&cap->session->s_cap_gen);
>      3715
>      3716         /* These are lost when the session goes away */
>      3717         if (S_ISDIR(inode->i_mode)) {
>      3718                 if (cap->issued & CEPH_CAP_DIR_CREATE) {
>      3719                         ceph_put_string(rcu_dereference_raw(ci->i_cached_layout.pool_ns));
>      3720                         memset(&ci->i_cached_layout, 0, sizeof(ci->i_cached_layout));
>      3721                 }
>      3722                 cap->issued &= ~CEPH_CAP_ANY_DIR_OPS;
>      3723         }
>      3724
>      3725         if (recon_state->msg_version >= 2) {
>      3726                 rec.v2.cap_id = cpu_to_le64(cap->cap_id);
>      3727                 rec.v2.wanted = cpu_to_le32(__ceph_caps_wanted(ci));
>      3728                 rec.v2.issued = cpu_to_le32(cap->issued);
>      3729                 rec.v2.snaprealm = cpu_to_le64(ci->i_snap_realm->ino);
> Delivered-To: xiubli@gapps.redhat.com
> Received: by 2002:a19:e206:0:0:0:0:0 with SMTP id z6csp4579254lfg;
>          Tue, 30 Nov 2021 02:41:06 -0800 (PST)
> X-Google-Smtp-Source: ABdhPJwWDIWEHMbMJsAs2t3SPX1hgNzDNylJen6S3qF2ohfuA62wcnJWQ39JYYyA8x9pBhsp0VDK
> X-Received: by 2002:a05:620a:4003:: with SMTP id h3mr42664809qko.225.1638268866826;
>          Tue, 30 Nov 2021 02:41:06 -0800 (PST)
> ARC-Seal: i=1; a=rsa-sha256; t=1638268866; cv=none;
>          d=google.com; s=arc-20160816;
>          b=ONkf3DH6PBRH65Nvlu2LJvYjMz6J7WKKlkjJGUVCKNGgyvGiuv9RzX0a8O4GbTose6
>           hsbPCvk4iU7uRxO91Adtp9GaI76DRQnMwn4WJuEPrjLgZ9B1JCcrHbEVwGLziBbUgzjq
>           ma21CxaF2HT1wx1X7aP0S6xWF4i/TusFiqV4EJtOpap6OAHKzoBv3kD7IHL6h1MaHEYN
>           1erWCjzclsXrm6V89Q6mzPYfNPmOuihTaCQaAb3THFvfajQ7ETJmUheigNZR9d3QLGAM
>           B+2h/AT+5IpenVOLCLt53jKxCFgUI+oaDtkk68fe8NNINiKBdhldo8DRj5zE5fO8uwSs
>           A2XQ==
> ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20160816;
>          h=content-disposition:list-id:precedence:mime-version:user-agent
>           :message-id:subject:cc:to:from:date:delivered-to;
>          bh=SxyDEL7tVdcV1aGVs0zKD5sJTikxvAbhnSCTkMxj5QI=;
>          b=j/4QndCMMuLjc7+JIhEOkrogOQqUIPLQY1/6LpRI8it2tthuIo3/v6oNe3haxVE/eE
>           Zq9anA46Ge/n8D7MCIG1C6vap5Jl5g89V6DKFdnn9ejKaa606Va2SoxgmljjnWdQ6nOj
>           CMKlMoU78g790DT/wkyAS7QGzoeh/Pk6ZsNAg70QlbFYRKGg1U8Er2xEJuXlmpOz6cWA
>           0d93i71kr0tgWBscq2f1mtJ0F77RcY+kdJ7ysuktk3ql5PoToTbrv3Hg515/dK+Zn1Fu
>           elBsEwv5u9dt1LwqSrjT5geangjP4TNEkfJwerDRlJvUPqWpCwyuMSb/zZbaAhFGr9B0
>           7pMg==
> ARC-Authentication-Results: i=1; mx.google.com;
>         spf=pass (google.com: domain of ceph-devel-owner@vger.kernel.org designates 23.128.96.18 as permitted sender) smtp.mailfrom=ceph-devel-owner@vger.kernel.org
> Return-Path: <ceph-devel-owner@vger.kernel.org>
> Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com. [207.211.31.120])
>          by mx.google.com with ESMTPS id c1si16667297qte.730.2021.11.30.02.41.06
>          for <xiubli@gapps.redhat.com>
>          (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
>          Tue, 30 Nov 2021 02:41:06 -0800 (PST)
> Received-SPF: pass (google.com: domain of ceph-devel-owner@vger.kernel.org designates 23.128.96.18 as permitted sender) client-ip=23.128.96.18;
> Authentication-Results: mx.google.com;
>         spf=pass (google.com: domain of ceph-devel-owner@vger.kernel.org designates 23.128.96.18 as permitted sender) smtp.mailfrom=ceph-devel-owner@vger.kernel.org
> Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
>   [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
>   (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
>   us-mta-31-V5r8CubgOB2xxwdAocAD7Q-1; Tue, 30 Nov 2021 05:41:05 -0500
> X-MC-Unique: V5r8CubgOB2xxwdAocAD7Q-1
> Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
> 	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
> 	(No client certificate requested)
> 	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0144D811E76
> 	for <xiubli@gapps.redhat.com>; Tue, 30 Nov 2021 10:41:05 +0000 (UTC)
> Received: by smtp.corp.redhat.com (Postfix)
> 	id F23DC1402400; Tue, 30 Nov 2021 10:41:04 +0000 (UTC)
> Delivered-To: xiubli@redhat.com
> Received: from mimecast-mx02.redhat.com (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
> 	by smtp.corp.redhat.com (Postfix) with ESMTPS id EBE641402406
> 	for <xiubli@redhat.com>; Tue, 30 Nov 2021 10:41:04 +0000 (UTC)
> Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
> 	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
> 	(No client certificate requested)
> 	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CB56C85A5BA
> 	for <xiubli@redhat.com>; Tue, 30 Nov 2021 10:41:04 +0000 (UTC)
> Received: from vger.kernel.org (vger.kernel.org [23.128.96.18]) by
>   relay.mimecast.com with ESMTP id us-mta-172-F30zQzmAM5qdD0bBpC5Jwg-1; Tue,
>   30 Nov 2021 05:40:17 -0500
> X-MC-Unique: F30zQzmAM5qdD0bBpC5Jwg-1
> Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
>          id S234677AbhK3KnW (ORCPT <rfc822;khiremat@redhat.com> + 87 others);
>          Tue, 30 Nov 2021 05:43:22 -0500
> Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:5022 "EHLO
>          mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
>          by vger.kernel.org with ESMTP id S234553AbhK3KnV (ORCPT
>          <rfc822;ceph-devel@vger.kernel.org>);
>          Tue, 30 Nov 2021 05:43:21 -0500
> Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
>          by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AU9TRdV020991;
>          Tue, 30 Nov 2021 10:40:00 GMT
> Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
>          by mx0b-00069f02.pphosted.com with ESMTP id 3cmvmwr9ch-1
>          (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
>          Tue, 30 Nov 2021 10:39:58 +0000
> Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
>          by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AUAVbBX094326;
>          Tue, 30 Nov 2021 10:39:57 GMT
> Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2044.outbound.protection.outlook.com [104.47.57.44])
>          by aserp3030.oracle.com with ESMTP id 3ckaqeejar-1
>          (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
>          Tue, 30 Nov 2021 10:39:57 +0000
> Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
>   (2603:10b6:301:2d::28) by MWHPR10MB1357.namprd10.prod.outlook.com
>   (2603:10b6:300:21::14) with Microsoft SMTP Server (version=TLS1_2,
>   cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Tue, 30 Nov
>   2021 10:39:56 +0000
> Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
>   ([fe80::7194:c377:36cc:d9f0]) by MWHPR1001MB2365.namprd10.prod.outlook.com
>   ([fe80::7194:c377:36cc:d9f0%6]) with mapi id 15.20.4734.024; Tue, 30 Nov 2021
>   10:39:56 +0000
> Date: Tue, 30 Nov 2021 13:39:47 +0300
> From: Dan Carpenter <dan.carpenter@oracle.com>
> To: zyan@redhat.com
> Cc: ceph-devel@vger.kernel.org
> Subject: [bug report] ceph: encode inodes' parent/d_name in cap reconnect
>   message
> Message-ID: <20211130103947.GA5827@kili>
> User-Agent: Mutt/1.10.1 (2018-07-13)
> X-ClientProxiedBy: ZR0P278CA0009.CHEP278.PROD.OUTLOOK.COM
>   (2603:10a6:910:16::19) To MWHPR1001MB2365.namprd10.prod.outlook.com
>   (2603:10b6:301:2d::28)
> MIME-Version: 1.0
> Received: from kili (102.222.70.114) by ZR0P278CA0009.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:16::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23 via Frontend Transport; Tue, 30 Nov 2021 10:39:54 +0000
> X-MS-PublicTrafficType: Email
> X-MS-Office365-Filtering-Correlation-Id: 50a19eb4-05c5-4ae4-eb3d-08d9b3edbfed
> X-MS-TrafficTypeDiagnostic: MWHPR10MB1357:
> X-Microsoft-Antispam-PRVS: <MWHPR10MB1357CD176A6FEB01B71521F18E679@MWHPR10MB1357.namprd10.prod.outlook.com>
> X-MS-Oob-TLC-OOBClassifiers: OLM:820
> X-MS-Exchange-SenderADCheck: 1
> X-MS-Exchange-AntiSpam-Relay: 0
> X-Microsoft-Antispam: BCL:0
> X-Microsoft-Antispam-Message-Info: FFd3zAkgAxXQuuU+tYOZoTgV4iUJQgf/nqidGENqNs2GK768lzF4GUMEe5oYJqhf5Ge3/hbM7J8c3In8ZCg9WUuAnIC5zmp/JKyIkrn/X0ndrS/avbbbB7xdLodiSviwcYPcUyoCAHjVY0uJffDmWiqUBOCKINZkNoe6tcV6XTXqEp3ole3vCjQImVaa7yWUszFCEst7bvnWRtqlfn/hi6eMsQTcgMirt2h1pw6r74Hn0E+2pSTWoVmLaz6r9yrjKDqtXUNHu4O53STYZG71U9qz+8ZS3QQvHiOHLSEWZIT4XNulWj82OjYaxRZOqolbZ42EOg4dJfcYlY7LC+jH6Js7okABZU8j9wHSYQiipIpmbD5p2Bf0Z1N5t8MyIWHZVWJgFPfq6fUXqg896UXpllDafh+Umz5qeH4gQdTv+eZM2GapTxjPpDXcIOg7w3MIV0ad0EBVWpkJrMg2F9HvIxua7OMET14cR1oSLh10J5/uhynwHjheXSuQ5ZejFzZs87OZZ2Xb+eCGL3XfF3LhZE69WWX0laufxmtelNM5z7dlBDz+xVV/IaKO8YVcOWkuJBbvN/KHhpeYcDcod8qQrjT2/UjpfWwQVqchN+SgFv+2CpkxvTBzTobbR+mvKc4Mcxlz/c7WssBa94ggb3+c1rw99af9D2kJJt4g3UoPu+Tw6jNGkRWC1UgZNGPTEueru+SP7ZFURUxQH9kc83hTPQ==
> X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2906002)(33716001)(9576002)(316002)(66476007)(8936002)(66946007)(44832011)(38100700002)(6666004)(83380400001)(38350700002)(956004)(15650500001)(9686003)(26005)(6496006)(186003)(5660300002)(86362001)(33656002)(508600001)(1076003)(8676002)(52116002)(6916009)(4326008)(66556008)(55016003);DIR:OUT;SFP:1101
> X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
> X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?w+sJIDxYl8A5Xa8n5GCy7gHsUZ+ECXyhJYgmjtJZcy1e7jyQY6MZddOc2XVF?=
>   =?us-ascii?Q?QvwXZKn3Lb2HwnblH++0jkv2CsgtIySR411i50Hv0+WYU1IbV1BAjSqx5gXE?=
>   =?us-ascii?Q?yuX38uha40obqleMl8jiyP4E/iXFKw+pcHVktLtfNCKq7fd5T9C33qO5jvhx?=
>   =?us-ascii?Q?16VZNJp/nkykp26TiXiG0BNIcSHXvTEjdO6ZKtRXLQCnrOWwRqZ1//oyHbvv?=
>   =?us-ascii?Q?gCqgdAYRPN2pVANk6irtx0RncdEnuS0oyBlMwvs7q+d8NWmzJnurI62dzO42?=
>   =?us-ascii?Q?+nQ7jzYOqXsy3RyNIgwt83DmIHO5cSC/piBgXKK8e6z4R6VQpSsoaduIAIkr?=
>   =?us-ascii?Q?pj4BaU26w9jyCBpctR2Irs7qmDMvZXqKfgClO346jnXGlM6J9v9ceewvuibZ?=
>   =?us-ascii?Q?6YHj4acFKBUETFI7QHmLjsEsLmjKEHwgYbBD/bqJROlBCwpF3mLzIigPswHB?=
>   =?us-ascii?Q?uhmIFwZUWzScmtfGDl6LzXH8hbucciFE2XQ11HRwGgos9GxCIALHm9BIvNVL?=
>   =?us-ascii?Q?p9LrM0oW/6KHoAwx1OotFaaw8cY4FBDB6K78Ayf5kuHVhyEaB5U7jkexW66s?=
>   =?us-ascii?Q?KEb3qT7i6VePg6GmCCvPPNW54eaQMWgOMTUMMlv2cPFUt5spD1ncsIT4kF4u?=
>   =?us-ascii?Q?ZtnQ0u0es3mTerBV+dxHzf0s/k/SS9ApoNHUbUlmU+UDB5B/d5TkMILogE9c?=
>   =?us-ascii?Q?Qer3C3T+IiyYhxPOlEFH0E9xhlntactv8ZrNkNuL5ij+9oFY80WOw2LznqVm?=
>   =?us-ascii?Q?3noTxacEDLnobNSs52RT/QpxhT9T0gOWonNvEj/ZeU3qILtjQ4Edf8HAPY4D?=
>   =?us-ascii?Q?DEzdBullACsk1XGv0ZhKA8TprDkF9X4ddz+7tEYfdYLnaKqF5cFNi/FX733N?=
>   =?us-ascii?Q?Ygc7+Z4wldSLPrYMuOeAvu0MwNyjI7LUvV+hsXZFPJJqrkdrly/xqhqv3PML?=
>   =?us-ascii?Q?U9hfwScDwH6yucTxJUJ5E0ju9zAVBRRLHQHVvr+s3oZhlxZ88A1u+j36GAea?=
>   =?us-ascii?Q?sf4+jiUYRAzUPJEUJu0FO6yyhSO8lXnICHU7jRVFQxVKCzBBbHcFtgkzvKRY?=
>   =?us-ascii?Q?wKibe+e7Yu6yo3cXsM3IbHiAdw9Q/K7ApYzEGaoholB5oJ9ZC/28D/nj11/b?=
>   =?us-ascii?Q?2INBP4WxYkUpVS4HQVa6ux7mjDyg4UZ5AH1viwIkdbLav4wUJ6ptu59+7AY/?=
>   =?us-ascii?Q?4F3TF6HXxg/+5DCAceMav6XDUAYuuJzHDSI8hb6vRBg2Q7qGcaL8vUU1UmI6?=
>   =?us-ascii?Q?1R7LFhYihAOyryzoyVSa9qOEggKkfcvO3rqbGLIJ7tlTo2WoQzHqNVw5Igjg?=
>   =?us-ascii?Q?lw8ZUzXjjaqUDaIiW0tM60w2VuwUVNxAp0M0/NQTeGkRf1L7CW1p17/T8LHB?=
>   =?us-ascii?Q?9QRCbVvXTPGj/1DKh369wiN9D5Bj6YVMMeue0J9+cxWoUuYMLVOJF1E177RW?=
>   =?us-ascii?Q?plOCbk7Cs9PldcIUZKpwizbVvJ4qq29EdZ0PjooYXJnWTQ20EMsjBR/beZD5?=
>   =?us-ascii?Q?EZ/8L2PyppreN4nD3N4Xe4OmZszjzSS45F3MM5dSXB9I2hBFOawkQmbRIpKK?=
>   =?us-ascii?Q?5oECdGYASFMIBWgVA0fQWfP2gQPbvJIPP56TVDupDQmH7DFkp55xRYuy1wyq?=
>   =?us-ascii?Q?b2KfifauV+dt1f+IrZzP0MnG7wz+2DeW+NwZfjBRRUGJXGYe8ul3HIbZnmYc?=
>   =?us-ascii?Q?inOZP373K+GBx5xeohjmfSUM+O8=3D?=
> X-OriginatorOrg: oracle.com
> X-MS-Exchange-CrossTenant-Network-Message-Id: 50a19eb4-05c5-4ae4-eb3d-08d9b3edbfed
> X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
> X-MS-Exchange-CrossTenant-AuthAs: Internal
> X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2021 10:39:55.9546
>   (UTC)
> X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
> X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
> X-MS-Exchange-CrossTenant-MailboxType: HOSTED
> X-MS-Exchange-CrossTenant-UserPrincipalName: bAIV9Ejqq30cEP2iX0FwCfBnlF1xXPdqMilkgZhDJHVTRXbnadrnCBBjPTf1qicbC074bYr+QZWs/TpLnHN2BxQV2utS0EDfSHYSORHi1f0=
> X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1357
> X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10183 signatures=668683
> X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
>   suspectscore=0 mlxlogscore=817 spamscore=0 phishscore=0 bulkscore=0
>   classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
>   definitions=main-2111300060
> X-Proofpoint-ORIG-GUID: b5Pff4bg7j2sZd9pnCPvwq3QS-dSWchm
> X-Proofpoint-GUID: b5Pff4bg7j2sZd9pnCPvwq3QS-dSWchm
> Precedence: bulk
> List-ID: <ceph-devel.vger.kernel.org>
> X-Mailing-List: ceph-devel@vger.kernel.org
> X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection Definition;Similar Internal Domain=false;Similar Monitored External Domain=false;Custom External Domain=false;Mimecast External Domain=false;Newly Observed Domain=false;Internal User Name=false;Custom Display Name List=false;Reply-to Address Mismatch=false;Targeted Threat Dictionary=false;Mimecast Threat Dictionary=false;Custom Threat Dictionary=false
> X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
> Authentication-Results: relay.mimecast.com;
> 	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=ceph-devel-owner@vger.kernel.org
> X-Mimecast-Spam-Score: 0
> X-Mimecast-Originator: vger.kernel.org
> Content-Type: text/plain; charset=us-ascii
> Content-Disposition: inline
>
> Hello Yan, Zheng,
>
> The patch a33f6432b3a6: "ceph: encode inodes' parent/d_name in cap
> reconnect message" from Aug 11, 2020, leads to the following Smatch
> static checker warning:
>
> 	fs/ceph/mds_client.c:3848 reconnect_caps_cb()
> 	error: uninitialized symbol 'pathlen'.
>
> fs/ceph/mds_client.c
>      3674 static int reconnect_caps_cb(struct inode *inode, struct ceph_cap *cap,
>      3675                           void *arg)
>      3676 {
>      3677         union {
>      3678                 struct ceph_mds_cap_reconnect v2;
>      3679                 struct ceph_mds_cap_reconnect_v1 v1;
>      3680         } rec;
>      3681         struct ceph_inode_info *ci = cap->ci;
>      3682         struct ceph_reconnect_state *recon_state = arg;
>      3683         struct ceph_pagelist *pagelist = recon_state->pagelist;
>      3684         struct dentry *dentry;
>      3685         char *path;
>      3686         int pathlen, err;
>      3687         u64 pathbase;
>      3688         u64 snap_follows;
>      3689
>      3690         dout(" adding %p ino %llx.%llx cap %p %lld %s\n",
>      3691              inode, ceph_vinop(inode), cap, cap->cap_id,
>      3692              ceph_cap_string(cap->issued));
>      3693
>      3694         dentry = d_find_primary(inode);
>      3695         if (dentry) {
>      3696                 /* set pathbase to parent dir when msg_version >= 2 */
>      3697                 path = ceph_mdsc_build_path(dentry, &pathlen, &pathbase,
>      3698                                             recon_state->msg_version >= 2);
>      3699                 dput(dentry);
>      3700                 if (IS_ERR(path)) {
>      3701                         err = PTR_ERR(path);
>      3702                         goto out_err;
>                                   ^^^^^^^^^^^^^
> "pathlen" is uninitialized on this goto.  It doesn't cause a bug.  It
> just looks weird.
>
>      3703                 }
>      3704         } else {
>      3705                 path = NULL;
>      3706                 pathlen = 0;
>      3707                 pathbase = 0;
>      3708         }
>      3709
>      3710         spin_lock(&ci->i_ceph_lock);
>      3711         cap->seq = 0;        /* reset cap seq */
>      3712         cap->issue_seq = 0;  /* and issue_seq */
>      3713         cap->mseq = 0;       /* and migrate_seq */
>      3714         cap->cap_gen = atomic_read(&cap->session->s_cap_gen);
>      3715
>      3716         /* These are lost when the session goes away */
>      3717         if (S_ISDIR(inode->i_mode)) {
>      3718                 if (cap->issued & CEPH_CAP_DIR_CREATE) {
>      3719                         ceph_put_string(rcu_dereference_raw(ci->i_cached_layout.pool_ns));
>      3720                         memset(&ci->i_cached_layout, 0, sizeof(ci->i_cached_layout));
>      3721                 }
>      3722                 cap->issued &= ~CEPH_CAP_ANY_DIR_OPS;
>      3723         }
>      3724
>      3725         if (recon_state->msg_version >= 2) {
>      3726                 rec.v2.cap_id = cpu_to_le64(cap->cap_id);
>      3727                 rec.v2.wanted = cpu_to_le32(__ceph_caps_wanted(ci));
>      3728                 rec.v2.issued = cpu_to_le32(cap->issued);
>      3729                 rec.v2.snaprealm = cpu_to_le64(ci->i_snap_realm->ino);
>      3730                 rec.v2.pathbase = cpu_to_le64(pathbase);
>      3731                 rec.v2.flock_len = (__force __le32)
>      3732                         ((ci->i_ceph_flags & CEPH_I_ERROR_FILELOCK) ? 0 : 1);
>      3733         } else {
>      3734                 rec.v1.cap_id = cpu_to_le64(cap->cap_id);
>      3735                 rec.v1.wanted = cpu_to_le32(__ceph_caps_wanted(ci));
>      3736                 rec.v1.issued = cpu_to_le32(cap->issued);
>      3737                 rec.v1.size = cpu_to_le64(i_size_read(inode));
>      3738                 ceph_encode_timespec64(&rec.v1.mtime, &inode->i_mtime);
>      3739                 ceph_encode_timespec64(&rec.v1.atime, &inode->i_atime);
>      3740                 rec.v1.snaprealm = cpu_to_le64(ci->i_snap_realm->ino);
>      3741                 rec.v1.pathbase = cpu_to_le64(pathbase);
>      3742         }
>      3743
>      3744         if (list_empty(&ci->i_cap_snaps)) {
>      3745                 snap_follows = ci->i_head_snapc ? ci->i_head_snapc->seq : 0;
>      3746         } else {
>      3747                 struct ceph_cap_snap *capsnap =
>      3748                         list_first_entry(&ci->i_cap_snaps,
>      3749                                          struct ceph_cap_snap, ci_item);
>      3750                 snap_follows = capsnap->follows;
>      3751         }
>      3752         spin_unlock(&ci->i_ceph_lock);
>      3753
>      3754         if (recon_state->msg_version >= 2) {
>      3755                 int num_fcntl_locks, num_flock_locks;
>      3756                 struct ceph_filelock *flocks = NULL;
>      3757                 size_t struct_len, total_len = sizeof(u64);
>      3758                 u8 struct_v = 0;
>      3759
>      3760 encode_again:
>      3761                 if (rec.v2.flock_len) {
>      3762                         ceph_count_locks(inode, &num_fcntl_locks, &num_flock_locks);
>      3763                 } else {
>      3764                         num_fcntl_locks = 0;
>      3765                         num_flock_locks = 0;
>      3766                 }
>      3767                 if (num_fcntl_locks + num_flock_locks > 0) {
>      3768                         flocks = kmalloc_array(num_fcntl_locks + num_flock_locks,
>      3769                                                sizeof(struct ceph_filelock),
>      3770                                                GFP_NOFS);
>      3771                         if (!flocks) {
>      3772                                 err = -ENOMEM;
>      3773                                 goto out_err;
>      3774                         }
>      3775                         err = ceph_encode_locks_to_buffer(inode, flocks,
>      3776                                                           num_fcntl_locks,
>      3777                                                           num_flock_locks);
>      3778                         if (err) {
>      3779                                 kfree(flocks);
>      3780                                 flocks = NULL;
>      3781                                 if (err == -ENOSPC)
>      3782                                         goto encode_again;
>      3783                                 goto out_err;
>      3784                         }
>      3785                 } else {
>      3786                         kfree(flocks);
>      3787                         flocks = NULL;
>      3788                 }
>      3789
>      3790                 if (recon_state->msg_version >= 3) {
>      3791                         /* version, compat_version and struct_len */
>      3792                         total_len += 2 * sizeof(u8) + sizeof(u32);
>      3793                         struct_v = 2;
>      3794                 }
>      3795                 /*
>      3796                  * number of encoded locks is stable, so copy to pagelist
>      3797                  */
>      3798                 struct_len = 2 * sizeof(u32) +
>      3799                             (num_fcntl_locks + num_flock_locks) *
>      3800                             sizeof(struct ceph_filelock);
>      3801                 rec.v2.flock_len = cpu_to_le32(struct_len);
>      3802
>      3803                 struct_len += sizeof(u32) + pathlen + sizeof(rec.v2);
>      3804
>      3805                 if (struct_v >= 2)
>      3806                         struct_len += sizeof(u64); /* snap_follows */
>      3807
>      3808                 total_len += struct_len;
>      3809
>      3810                 if (pagelist->length + total_len > RECONNECT_MAX_SIZE) {
>      3811                         err = send_reconnect_partial(recon_state);
>      3812                         if (err)
>      3813                                 goto out_freeflocks;
>      3814                         pagelist = recon_state->pagelist;
>      3815                 }
>      3816
>      3817                 err = ceph_pagelist_reserve(pagelist, total_len);
>      3818                 if (err)
>      3819                         goto out_freeflocks;
>      3820
>      3821                 ceph_pagelist_encode_64(pagelist, ceph_ino(inode));
>      3822                 if (recon_state->msg_version >= 3) {
>      3823                         ceph_pagelist_encode_8(pagelist, struct_v);
>      3824                         ceph_pagelist_encode_8(pagelist, 1);
>      3825                         ceph_pagelist_encode_32(pagelist, struct_len);
>      3826                 }
>      3827                 ceph_pagelist_encode_string(pagelist, path, pathlen);
>      3828                 ceph_pagelist_append(pagelist, &rec, sizeof(rec.v2));
>      3829                 ceph_locks_to_pagelist(flocks, pagelist,
>      3830                                        num_fcntl_locks, num_flock_locks);
>      3831                 if (struct_v >= 2)
>      3832                         ceph_pagelist_encode_64(pagelist, snap_follows);
>      3833 out_freeflocks:
>      3834                 kfree(flocks);
>      3835         } else {
>      3836                 err = ceph_pagelist_reserve(pagelist,
>      3837                                             sizeof(u64) + sizeof(u32) +
>      3838                                             pathlen + sizeof(rec.v1));
>      3839                 if (err)
>      3840                         goto out_err;
>      3841
>      3842                 ceph_pagelist_encode_64(pagelist, ceph_ino(inode));
>      3843                 ceph_pagelist_encode_string(pagelist, path, pathlen);
>      3844                 ceph_pagelist_append(pagelist, &rec, sizeof(rec.v1));
>      3845         }
>      3846
>      3847 out_err:
> --> 3848         ceph_mdsc_free_path(path, pathlen);
>      3849         if (!err)
>      3850                 recon_state->nr_caps++;
>      3851         return err;
>      3852 }
>
> regards,
> dan carpenter
>
>      3730                 rec.v2.pathbase = cpu_to_le64(pathbase);
>      3731                 rec.v2.flock_len = (__force __le32)
>      3732                         ((ci->i_ceph_flags & CEPH_I_ERROR_FILELOCK) ? 0 : 1);
>      3733         } else {
>      3734                 rec.v1.cap_id = cpu_to_le64(cap->cap_id);
>      3735                 rec.v1.wanted = cpu_to_le32(__ceph_caps_wanted(ci));
>      3736                 rec.v1.issued = cpu_to_le32(cap->issued);
>      3737                 rec.v1.size = cpu_to_le64(i_size_read(inode));
>      3738                 ceph_encode_timespec64(&rec.v1.mtime, &inode->i_mtime);
>      3739                 ceph_encode_timespec64(&rec.v1.atime, &inode->i_atime);
>      3740                 rec.v1.snaprealm = cpu_to_le64(ci->i_snap_realm->ino);
>      3741                 rec.v1.pathbase = cpu_to_le64(pathbase);
>      3742         }
>      3743
>      3744         if (list_empty(&ci->i_cap_snaps)) {
>      3745                 snap_follows = ci->i_head_snapc ? ci->i_head_snapc->seq : 0;
>      3746         } else {
>      3747                 struct ceph_cap_snap *capsnap =
>      3748                         list_first_entry(&ci->i_cap_snaps,
>      3749                                          struct ceph_cap_snap, ci_item);
>      3750                 snap_follows = capsnap->follows;
>      3751         }
>      3752         spin_unlock(&ci->i_ceph_lock);
>      3753
>      3754         if (recon_state->msg_version >= 2) {
>      3755                 int num_fcntl_locks, num_flock_locks;
>      3756                 struct ceph_filelock *flocks = NULL;
>      3757                 size_t struct_len, total_len = sizeof(u64);
>      3758                 u8 struct_v = 0;
>      3759
>      3760 encode_again:
>      3761                 if (rec.v2.flock_len) {
>      3762                         ceph_count_locks(inode, &num_fcntl_locks, &num_flock_locks);
>      3763                 } else {
>      3764                         num_fcntl_locks = 0;
>      3765                         num_flock_locks = 0;
>      3766                 }
>      3767                 if (num_fcntl_locks + num_flock_locks > 0) {
>      3768                         flocks = kmalloc_array(num_fcntl_locks + num_flock_locks,
>      3769                                                sizeof(struct ceph_filelock),
>      3770                                                GFP_NOFS);
>      3771                         if (!flocks) {
>      3772                                 err = -ENOMEM;
>      3773                                 goto out_err;
>      3774                         }
>      3775                         err = ceph_encode_locks_to_buffer(inode, flocks,
>      3776                                                           num_fcntl_locks,
>      3777                                                           num_flock_locks);
>      3778                         if (err) {
>      3779                                 kfree(flocks);
>      3780                                 flocks = NULL;
>      3781                                 if (err == -ENOSPC)
>      3782                                         goto encode_again;
>      3783                                 goto out_err;
>      3784                         }
>      3785                 } else {
>      3786                         kfree(flocks);
>      3787                         flocks = NULL;
>      3788                 }
>      3789
>      3790                 if (recon_state->msg_version >= 3) {
>      3791                         /* version, compat_version and struct_len */
>      3792                         total_len += 2 * sizeof(u8) + sizeof(u32);
>      3793                         struct_v = 2;
>      3794                 }
>      3795                 /*
>      3796                  * number of encoded locks is stable, so copy to pagelist
>      3797                  */
>      3798                 struct_len = 2 * sizeof(u32) +
>      3799                             (num_fcntl_locks + num_flock_locks) *
>      3800                             sizeof(struct ceph_filelock);
>      3801                 rec.v2.flock_len = cpu_to_le32(struct_len);
>      3802
>      3803                 struct_len += sizeof(u32) + pathlen + sizeof(rec.v2);
>      3804
>      3805                 if (struct_v >= 2)
>      3806                         struct_len += sizeof(u64); /* snap_follows */
>      3807
>      3808                 total_len += struct_len;
>      3809
>      3810                 if (pagelist->length + total_len > RECONNECT_MAX_SIZE) {
>      3811                         err = send_reconnect_partial(recon_state);
>      3812                         if (err)
>      3813                                 goto out_freeflocks;
>      3814                         pagelist = recon_state->pagelist;
>      3815                 }
>      3816
>      3817                 err = ceph_pagelist_reserve(pagelist, total_len);
>      3818                 if (err)
>      3819                         goto out_freeflocks;
>      3820
>      3821                 ceph_pagelist_encode_64(pagelist, ceph_ino(inode));
>      3822                 if (recon_state->msg_version >= 3) {
>      3823                         ceph_pagelist_encode_8(pagelist, struct_v);
>      3824                         ceph_pagelist_encode_8(pagelist, 1);
>      3825                         ceph_pagelist_encode_32(pagelist, struct_len);
>      3826                 }
>      3827                 ceph_pagelist_encode_string(pagelist, path, pathlen);
>      3828                 ceph_pagelist_append(pagelist, &rec, sizeof(rec.v2));
>      3829                 ceph_locks_to_pagelist(flocks, pagelist,
>      3830                                        num_fcntl_locks, num_flock_locks);
>      3831                 if (struct_v >= 2)
>      3832                         ceph_pagelist_encode_64(pagelist, snap_follows);
>      3833 out_freeflocks:
>      3834                 kfree(flocks);
>      3835         } else {
>      3836                 err = ceph_pagelist_reserve(pagelist,
>      3837                                             sizeof(u64) + sizeof(u32) +
>      3838                                             pathlen + sizeof(rec.v1));
>      3839                 if (err)
>      3840                         goto out_err;
>      3841
>      3842                 ceph_pagelist_encode_64(pagelist, ceph_ino(inode));
>      3843                 ceph_pagelist_encode_string(pagelist, path, pathlen);
>      3844                 ceph_pagelist_append(pagelist, &rec, sizeof(rec.v1));
>      3845         }
>      3846
>      3847 out_err:
> --> 3848         ceph_mdsc_free_path(path, pathlen);
>      3849         if (!err)
>      3850                 recon_state->nr_caps++;
>      3851         return err;
>      3852 }
>
> regards,
> dan carpenter
>

