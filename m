Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A121D15EE07
	for <lists+ceph-devel@lfdr.de>; Fri, 14 Feb 2020 18:38:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390420AbgBNRh6 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+ceph-devel@lfdr.de>); Fri, 14 Feb 2020 12:37:58 -0500
Received: from m9a0014g.houston.softwaregrp.com ([15.124.64.90]:47154 "EHLO
        m9a0014g.houston.softwaregrp.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387509AbgBNRh5 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 14 Feb 2020 12:37:57 -0500
Received: FROM m9a0014g.houston.softwaregrp.com (15.121.0.190) BY m9a0014g.houston.softwaregrp.com WITH ESMTP
 FOR ceph-devel@vger.kernel.org;
 Fri, 14 Feb 2020 17:36:47 +0000
Received: from M4W0334.microfocus.com (2002:f78:1192::f78:1192) by
 M9W0067.microfocus.com (2002:f79:be::f79:be) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10; Fri, 14 Feb 2020 17:16:10 +0000
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (15.124.8.11) by
 M4W0334.microfocus.com (15.120.17.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10 via Frontend Transport; Fri, 14 Feb 2020 17:16:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S1oi9503rGYmnj4Tpyck7fUjbhZsklYRAkh0AXDM/BXI/4cDx71i0SreyC+M2a7SDD5f3Kb30beeu47h8P32fmftYCMbPmnf135eq6LGKyqSTFnB5LHe9rHe/wyMpMrYQctH2FwaX/Gwsj5qMM3SC8qwR2r4IxQJAv3TlgpeJjPJxdyj2jtdPS3bjqhwrCewjN2aRbtQzrHeu0RUCHdOq3Cg4KKL+czc4cZdASMKuRDSfFvTg8ksrF4b3e9F34j9jEz0fVZ9kC3mVuC2kqNPzcRi9RlMdWEZNYy2EAoqPrf+1VcWZw52cfiagJc0YOaZfIgWT35h9LrG6lkLCQ0ixA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EOqRd6clwGqSDfegMQp88FzQWVT+DE3FCxOq43GmELE=;
 b=bl6AdaJiC5/9qK29cyW6MJZnSFaYaGbWLezr1oinG8+VFNWznjQV5p+3o8c7B2/BbBJzx+9WIyPi1QAhwUnT03AuNsyYudmiE+0CGqNj3WI6tpIAQbrqg4pD9vhcVaagkkOio6jJv+pVcyiFX4iSV/Rp9VUuEU+9yVo2hAsqOFXAYCuN6Zo/Vqg8ob57/4G8Sfya9t6JDSDRZ+VfqzhByrGkYqfXvUzbJbyxmidIDU//E8OXPpeJ6G7ooEL+WN6hohnZW92BuGXXG8EQMuY4Cim7JSWZU2FN+NZGk8pXG21Dr92UMC9dZg5WPq61JaL+tvpc8Qi4MfgZoY2ZHAN9fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jan.Fajerski@suse.com; 
Received: from BN6PR1801MB2036.namprd18.prod.outlook.com (10.161.156.165) by
 BN6PR1801MB1892.namprd18.prod.outlook.com (10.161.153.36) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.24; Fri, 14 Feb 2020 17:16:05 +0000
Received: from BN6PR1801MB2036.namprd18.prod.outlook.com
 ([fe80::b500:e7c2:123c:c66e]) by BN6PR1801MB2036.namprd18.prod.outlook.com
 ([fe80::b500:e7c2:123c:c66e%6]) with mapi id 15.20.2707.031; Fri, 14 Feb 2020
 17:16:05 +0000
Date:   Fri, 14 Feb 2020 18:15:54 +0100
From:   Jan Fajerski <jfajerski@suse.com>
To:     Yuri Weinstein <yweinste@redhat.com>
CC:     <dev@ceph.io>, "Development, Ceph" <ceph-devel@vger.kernel.org>,
        Abhishek Lekshmanan <abhishek@suse.com>,
        Nathan Cutler <ncutler@suse.cz>,
        Casey Bodley <cbodley@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Neha Ojha <nojha@redhat.com>,
        "Durgin, Josh" <jdurgin@redhat.com>,
        David Zafman <dzafman@redhat.com>,
        "Weil, Sage" <sweil@redhat.com>,
        Ramana Venkatesh Raja <rraja@redhat.com>,
        Tamilarasi Muthamizhan <tmuthami@redhat.com>,
        "Dillaman, Jason" <dillaman@redhat.com>,
        "Sadeh-Weinraub, Yehuda" <yehuda@redhat.com>,
        "Lekshmanan, Abhishek" <abhishek.lekshmanan@gmail.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@redhat.com>,
        ceph-qe-team <ceph-qe-team@redhat.com>,
        Andrew Schoen <aschoen@redhat.com>, ceph-qa <ceph-qa@ceph.com>,
        Matt Benjamin <mbenjamin@redhat.com>,
        Sebastien Han <shan@redhat.com>,
        Brad Hubbard <bhubbard@redhat.com>,
        Venky Shankar <vshankar@redhat.com>,
        David Galloway <dgallowa@redhat.com>,
        Milind Changire <mchangir@redhat.com>
Subject: Re: Readiness for 14.2.8 ?
Message-ID: <20200214171554.l7ibzoo64uthd2ke@jfsuselaptop>
Mail-Followup-To: Yuri Weinstein <yweinste@redhat.com>, dev@ceph.io,
        "Development, Ceph" <ceph-devel@vger.kernel.org>,
        Abhishek Lekshmanan <abhishek@suse.com>,
        Nathan Cutler <ncutler@suse.cz>, Casey Bodley <cbodley@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Neha Ojha <nojha@redhat.com>, "Durgin, Josh" <jdurgin@redhat.com>,
        David Zafman <dzafman@redhat.com>, "Weil, Sage" <sweil@redhat.com>,
        Ramana Venkatesh Raja <rraja@redhat.com>,
        Tamilarasi Muthamizhan <tmuthami@redhat.com>,
        "Dillaman, Jason" <dillaman@redhat.com>,
        "Sadeh-Weinraub, Yehuda" <yehuda@redhat.com>,
        "Lekshmanan, Abhishek" <abhishek.lekshmanan@gmail.com>,
        Ilya Dryomov <idryomov@gmail.com>, Jeff Layton <jlayton@redhat.com>,
        ceph-qe-team <ceph-qe-team@redhat.com>,
        Andrew Schoen <aschoen@redhat.com>, ceph-qa <ceph-qa@ceph.com>,
        Matt Benjamin <mbenjamin@redhat.com>,
        Sebastien Han <shan@redhat.com>, Brad Hubbard <bhubbard@redhat.com>,
        Venky Shankar <vshankar@redhat.com>,
        David Galloway <dgallowa@redhat.com>,
        Milind Changire <mchangir@redhat.com>
References: <CAMMFjmGWrhC_gd3wY5SfqfSB6O=0Tp_QRAu0ibMTDPVrja2HSg@mail.gmail.com>
Content-Type: text/plain; charset="iso-8859-15"; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <CAMMFjmGWrhC_gd3wY5SfqfSB6O=0Tp_QRAu0ibMTDPVrja2HSg@mail.gmail.com>
X-ClientProxiedBy: AM5PR0601CA0038.eurprd06.prod.outlook.com
 (2603:10a6:203:68::24) To BN6PR1801MB2036.namprd18.prod.outlook.com
 (2603:10b6:405:6b::37)
MIME-Version: 1.0
Received: from localhost (93.202.229.35) by AM5PR0601CA0038.eurprd06.prod.outlook.com (2603:10a6:203:68::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.22 via Frontend Transport; Fri, 14 Feb 2020 17:15:59 +0000
X-Originating-IP: [93.202.229.35]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9ffebf8e-d97e-4dfc-a2d4-08d7b1719002
X-MS-TrafficTypeDiagnostic: BN6PR1801MB1892:
X-LD-Processed: 856b813c-16e5-49a5-85ec-6f081e13b527,ExtFwd
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN6PR1801MB18920D6FC32A522CAD4A85A6E5150@BN6PR1801MB1892.namprd18.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-Forefront-PRVS: 03137AC81E
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(7916004)(4636009)(136003)(366004)(39860400002)(346002)(396003)(376002)(199004)(189003)(7116003)(16526019)(7416002)(33716001)(6666004)(4326008)(956004)(9686003)(54906003)(6486002)(1076003)(26005)(186003)(2906002)(81156014)(5660300002)(478600001)(66476007)(66556008)(4744005)(66574012)(81166006)(52116002)(66946007)(6496006)(8936002)(6916009)(316002)(8676002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN6PR1801MB1892;H:BN6PR1801MB2036.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: suse.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g0RZXwV9IVcxTvVn/KiwhLQp2uVUC94j2uFcz1gK6wTZOZhkjth0IeWc1lU88kHvCKusphVgjfkWeK8KzKsEpr19BfxLhnJCAz+B/A1t6/XvA9T5SJkxWBnTsoQI9yRgkjjMSyJxNCd1IWks4L3DS8R6t273FUNiVEZhlKn/fhAYLqgVMlSGDidCaK6gYt/xUU+JonT7upizhaYo4jRkRHg130p0TfP5TuBqvh7RyLsQgvi9VO8xaOtJcNI07kY5hkbV83YRsyLFDx+OpyI1kKEVgQxv2jDJtofUoQ76KED1o3gYQm5D4ghphn+3vW5ifb9rqEe2M1qzn9H9bNEpIJXj9D24CzWT4zbNiVklH/rPg+au5RUdWXuA0JJLQUb61qGK/cZVvr5LadBZ2aVQS3xpD/GtBySmCc0ZMrkJeZMxAHuRC78L2DUdTLfPjfzQ7q/zivlcbGzS7VfcXJJuLc4LRNNRgnRKvcHs9/UQdMD6PCZtRYwLNuVhvNX7dn6ixx/8RuVnyKB0RoSBlNJYLA==
X-MS-Exchange-AntiSpam-MessageData: Kp0snBZ1vlC80mWIIY8dlKAH7qOWmUNbaQInfnTqgfQ9haTq+ZnVJKzWrWTFQUCUgzG4F5b41t4dmPpe6ro77soren3dU4AY02pFnH1L5Ry1xQTgQc6ylu9JvKn3BvuOeRx103/kBJljl8bt7X9vfA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ffebf8e-d97e-4dfc-a2d4-08d7b1719002
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2020 17:16:00.8363
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 856b813c-16e5-49a5-85ec-6f081e13b527
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X1pnpgsbc6L0kIZLC09omgk66twIGkRFV4+AkIzeKKv+t/NXsObVHQoeQjwfk5AAxrphQd9wwHAHx1XqrvdwEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1801MB1892
X-OriginatorOrg: suse.com
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Feb 10, 2020 at 11:57:19AM -0800, Yuri Weinstein wrote:
>Below is the current queue of PRs:
>https://github.com/ceph/ceph/pulls?page=2&q=is%3Aopen+label%3Anautilus-batch-1+label%3Aneeds-qa
>
>Most PRs are being tested.
>Unless there are objections, we will start QE validation as soon as
>all PRs in this queue were merged.
>
>Dev leads - pls add and tag all RRs that must be included.
ceph-volume is ready, al backports are merged and tested (thank you Nathan!).
>
>Thx
>YuriW
>

-- 
Jan Fajerski
Senior Software Engineer Enterprise Storage
SUSE Software Solutions Germany GmbH
Maxfeldstr. 5, 90409 Nürnberg, Germany
(HRB 36809, AG Nürnberg)
Geschäftsführer: Felix Imendörffer
