Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 763901757C2
	for <lists+ceph-devel@lfdr.de>; Mon,  2 Mar 2020 10:57:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727409AbgCBJ5G convert rfc822-to-8bit (ORCPT
        <rfc822;lists+ceph-devel@lfdr.de>); Mon, 2 Mar 2020 04:57:06 -0500
Received: from m4a0073g.houston.softwaregrp.com ([15.124.2.131]:43335 "EHLO
        m4a0073g.houston.softwaregrp.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726956AbgCBJ5G (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 2 Mar 2020 04:57:06 -0500
Received: FROM m4a0073g.houston.softwaregrp.com (15.120.17.147) BY m4a0073g.houston.softwaregrp.com WITH ESMTP;
 Mon,  2 Mar 2020 09:54:57 +0000
Received: from M9W0067.microfocus.com (2002:f79:be::f79:be) by
 M4W0335.microfocus.com (2002:f78:1193::f78:1193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10; Mon, 2 Mar 2020 09:46:15 +0000
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (15.124.72.14) by
 M9W0067.microfocus.com (15.121.0.190) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10 via Frontend Transport; Mon, 2 Mar 2020 09:46:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O6FzdjLfwKb7aGZ5ARmA/bofPr3hrTTmluZQ61AdpXh5VjyVHpQzQqpFWVL3mKetrNZJa+mr4PkWk/0TDLWMuNm0sqZfAROEm1pEbOyFfm89YbNnlEO9OI2cueePtVJ3EENg2agzcFF6l23CY4zOVWv4iAHaq8/41MfO2SSs7G+o0O+QI20LsN32Kis0ZdtKR75aId6ScURvjU2umNATbf+GuI9VZLs5wjpSGKn+F5ro2VGMUXSjSrvrppw7zFA2j6ub+MuN8ENWIibr3fTol390nOjchqyrUZghbT5OmDUVBuAdJytoCRIMuLSZCn27e8Lau/bFRc1PWVGNoMmVBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O1xaE9m3LuxBNeMo7coaFVDDeOJypRtyAECmonCgaaA=;
 b=cvWIRfW/Dl983xwI+KxFY6TixUyR7Sj3EaM3QPSZxgtw8EQ3aJXIfboz7slPIJtbf726VI5EtdD6SeIfqzh6nnLnCwUEEp1J/EQwVDM1q4/kqVAFK4OLoGEcrdT5eZyXIFInjhqxVzhxoD/o+XXX+iEQywb/nH/4SccxVZeyEbgAObF3STMCZyM8NjnXRV63CqCHz4zngMpvHQj73jPNkkQTeKhAH/ECG66ifmZ+mtUDcW8dFXp8Ni6/UOS3WtRvyzu640Hk0ptwQoroaBzkbG5KWLK5BXjQR6nuprgn16+ltZW4m8dpYuo9iv8ZuZyWgKeLoWi8G5+UwKkkzw7SRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jan.Fajerski@suse.com; 
Received: from BN6PR1801MB2036.namprd18.prod.outlook.com
 (2603:10b6:405:6b::37) by BN6PR1801MB1908.namprd18.prod.outlook.com
 (2603:10b6:405:64::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.18; Mon, 2 Mar
 2020 09:46:12 +0000
Received: from BN6PR1801MB2036.namprd18.prod.outlook.com
 ([fe80::ca7:a26c:9708:d3d]) by BN6PR1801MB2036.namprd18.prod.outlook.com
 ([fe80::ca7:a26c:9708:d3d%6]) with mapi id 15.20.2772.019; Mon, 2 Mar 2020
 09:46:12 +0000
Date:   Mon, 2 Mar 2020 10:46:06 +0100
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
Subject: Re: Readiness for v13.2.9?
Message-ID: <20200302094606.scn3hp6huakwpb3o@jfsuselaptop>
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
References: <CAMMFjmFAB2E_h7VhrCOBz-EUHHk0nrB=JSudfcOhCpA7FwNd6w@mail.gmail.com>
Content-Type: text/plain; charset="iso-8859-15"; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <CAMMFjmFAB2E_h7VhrCOBz-EUHHk0nrB=JSudfcOhCpA7FwNd6w@mail.gmail.com>
X-ClientProxiedBy: AM7PR02CA0021.eurprd02.prod.outlook.com
 (2603:10a6:20b:100::31) To BN6PR1801MB2036.namprd18.prod.outlook.com
 (2603:10b6:405:6b::37)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (93.202.234.240) by AM7PR02CA0021.eurprd02.prod.outlook.com (2603:10a6:20b:100::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.15 via Frontend Transport; Mon, 2 Mar 2020 09:46:11 +0000
X-Originating-IP: [93.202.234.240]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 197e1299-43f4-46cc-f043-08d7be8e8a75
X-MS-TrafficTypeDiagnostic: BN6PR1801MB1908:
X-LD-Processed: 856b813c-16e5-49a5-85ec-6f081e13b527,ExtFwd
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN6PR1801MB1908DEDB07DFFE7BBF8872C0E5E70@BN6PR1801MB1908.namprd18.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 033054F29A
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(7916004)(4636009)(39860400002)(346002)(376002)(136003)(396003)(366004)(189003)(199004)(316002)(478600001)(52116002)(6496006)(66946007)(956004)(54906003)(66556008)(66476007)(4744005)(66574012)(16526019)(1076003)(2906002)(6666004)(33716001)(6916009)(8676002)(6486002)(7416002)(81156014)(81166006)(186003)(8936002)(9686003)(26005)(4326008)(5660300002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN6PR1801MB1908;H:BN6PR1801MB2036.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: suse.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cfdswK8pxYl/KJt47v4OsReTEZSKLCNz3E1TsCixoTufX05zymjMVAUJlQRtxZBm2/YwkXEY3R+Zu8yrgj040T6DTNQy7R5vcFUvo6EGGqJj9ysMxjey86G5rQjAF73u+C7gDnlIKqUTlb062RH7qo5jg2oCatt4iJrvP+Mg6qslpg8AxXgD+hdFotZtPen468siw8uVh0TIzH3LRLshjASHtufIDOTk7q5+AjXnWwB8F2i4KqoCFd+IlQl1S9L+bTIbwrOHrP19bGraLgeNHfBCHzAoRKWLqIYk9RoFxLJmUDm8CmIgGEE3ktW/Eof/JALWRGtxTeAaVHHERCJZYbmv2DnLCjc0IrfI5A9bYxa+NAPDmbowJNHN4C18hsTvmaeu6YC7WcqfyTNNOhAeXydYET8x/yAW0wwvYXltRHtv7Jg8jatsanQQ2HAAaXxcRuE2pBkwAX9U2QeTzSHQf5W991AIzKgeczyNyRWcmxlLBIHE62wDT8EPcRmgsi/InAUqL3xY7V6J0/6vuGvMgg==
X-MS-Exchange-AntiSpam-MessageData: CqF4LBRpKh/c8EQhJ7xTF0jEq/KPFlprgNVFhpWhjIzMr7VIhPtu2QrEM8wItcE44AxF/V6UmNFZ9Vouee+md3gbVMUsn/O4BaBFwz4Qe/Borz2fWgmFNG+yVOs2ph2hBd1lWaTkmTzuwe7M2LjKTg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 197e1299-43f4-46cc-f043-08d7be8e8a75
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2020 09:46:11.8870
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 856b813c-16e5-49a5-85ec-6f081e13b527
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ogF7Krc1JeOAxeRfqnQDwWKVZ6vYRRhfyGRZDfNphlw0uUKGuXCd2VNuxAOif/dtT/Y7RJmECZpZuCJ2Q9J3cA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1801MB1908
X-OriginatorOrg: suse.com
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Feb 26, 2020 at 04:07:28PM -0800, Yuri Weinstein wrote:
>Below is the current queue of PRs:
>https://github.com/ceph/ceph/pulls?q=is%3Aopen+label%3Amimic-batch-1+label%3Aneeds-qa
>
>Dev leads - pls add and tag all RRs that must be included.
ceph-volume is caught up on backports and ready to go.
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
