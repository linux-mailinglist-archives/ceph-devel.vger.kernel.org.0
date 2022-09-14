Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 938B25B8992
	for <lists+ceph-devel@lfdr.de>; Wed, 14 Sep 2022 15:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbiINN7E (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 14 Sep 2022 09:59:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbiINN7D (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 14 Sep 2022 09:59:03 -0400
Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01hn2211.outbound.protection.outlook.com [52.100.0.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C4D87645F
        for <ceph-devel@vger.kernel.org>; Wed, 14 Sep 2022 06:59:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OtJiDh+An2rgFBFL3BcqPTiQbX00yNZnXsTt+e5T+QGyE25PD0oqY2Z3pf9kIMUfGGghjtGOcUXMP8ju1o8ZJp135bOKOHtVQDk7LMgj+FTUGC6IWooUnoJ5eRuG806LE/NuFilp/6xyGgdgDGboVtjmMN90/Y2sO6f1lbmWVUw24s5AAL9KVVtD564pn1iAZnk81o/DsYFxspttA72umE2m9LCz39Jo6CyS6Z+fG6hpsXqQAOjNmVfrPPhB7j4l/70jNue8n2pVQhkq5Kgm/TKcrOy5xetnHEGVhXspwedkywdJb+JVHesuUsPGq3YgpENEyA4rtPt6IZ98MDJw7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bs10Md+15nMnyayKLyd22Uv+/ZH79IcFcpzuzGLq1Fg=;
 b=lgqeu9TGru032VgtwohnIoXDRxn+H5Nt+PDyioojI3nxQvHxgWl2yJrne2kpL5FBwhpLf9YOZMzIBJZSYy1rnO7qHq8Da/89XYLrDes/gadaK90SFAAEFl5dtnWSBO+vIRHWVTJQm2bwm5sZc74M8zChdtDBEf7/ujNwqqixmuWzmZaQpY/fl+70y8H9A1MIZAFeV5XEU2XVkFK2E1tsaNlhjgHt9sN77maPxJgThX7wTKpIw7EXMNuBunFojeDVdkZBbsi6Zli4jw02EJNrkavygVpVv8SBXrVZBMw/EZmbKWSlls5mT8kflLOfYiDJz6t8yvUmuRWGJeRjsEsqag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 37.19.199.139) smtp.rcpttodomain=uho.edu.cu smtp.mailfrom=t4.cims.jp;
 dmarc=bestguesspass action=none header.from=t4.cims.jp; dkim=none (message
 not signed); arc=none (0)
Received: from SG2PR04CA0202.apcprd04.prod.outlook.com (2603:1096:4:187::20)
 by PUZPR04MB6216.apcprd04.prod.outlook.com (2603:1096:301:ed::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14; Wed, 14 Sep
 2022 13:58:59 +0000
Received: from SG2APC01FT0064.eop-APC01.prod.protection.outlook.com
 (2603:1096:4:187:cafe::d8) by SG2PR04CA0202.outlook.office365.com
 (2603:1096:4:187::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.15 via Frontend
 Transport; Wed, 14 Sep 2022 13:58:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 37.19.199.139)
 smtp.mailfrom=t4.cims.jp; dkim=none (message not signed)
 header.d=none;dmarc=bestguesspass action=none header.from=t4.cims.jp;
Received-SPF: Pass (protection.outlook.com: domain of t4.cims.jp designates
 37.19.199.139 as permitted sender) receiver=protection.outlook.com;
 client-ip=37.19.199.139; helo=User; pr=M
Received: from mail.prasarana.com.my (58.26.8.158) by
 SG2APC01FT0064.mail.protection.outlook.com (10.13.36.172) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5632.12 via Frontend Transport; Wed, 14 Sep 2022 13:58:58 +0000
Received: from MRL-EXH-02.prasarana.com.my (10.128.66.101) by
 MRL-EXH-01.prasarana.com.my (10.128.66.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Wed, 14 Sep 2022 21:58:49 +0800
Received: from User (37.19.199.139) by MRL-EXH-02.prasarana.com.my
 (10.128.66.101) with Microsoft SMTP Server id 15.1.2176.14 via Frontend
 Transport; Wed, 14 Sep 2022 21:58:15 +0800
Reply-To: <rhashimi202222@kakao.com>
From:   Consultant Swift Capital Loans Ltd <info@t4.cims.jp>
Subject: I hope you are doing well, and business is great!
Date:   Wed, 14 Sep 2022 21:58:57 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset="Windows-1251"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2600.0000
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2600.0000
Message-ID: <bd775151-e79e-48fe-b092-4fbb4bc56464@MRL-EXH-02.prasarana.com.my>
To:     Undisclosed recipients:;
X-EOPAttributedMessage: 0
X-MS-Exchange-SkipListedInternetSender: ip=[37.19.199.139];domain=User
X-MS-Exchange-ExternalOriginalInternetSender: ip=[37.19.199.139];domain=User
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SG2APC01FT0064:EE_|PUZPR04MB6216:EE_
X-MS-Office365-Filtering-Correlation-Id: 7e6700ec-9ecb-4204-10c4-08da9659453c
X-MS-Exchange-AtpMessageProperties: SA|SL
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?windows-1251?Q?zkW99G35XqS1suowMVKVgq/Q+7QuxovgCKFzoip2aNdD6PrqMW3Jxpfa?=
 =?windows-1251?Q?rTqaIgFKEtCOzGYiOe8V77binbb9upXJHDHYWQgDRe9GwOxvZsouEZDn?=
 =?windows-1251?Q?WnkmBYXMwjMm8HzO8WFYVNyZct5fGD/tVW0fTEQMJ2VTixP8dvVKA8Uh?=
 =?windows-1251?Q?BI18hxExq4pigNuyjXsBeRBg3jJs3owlRAM24Is07qGd6tZXSoBacihb?=
 =?windows-1251?Q?zVJdd6lEQ4E4/EXx4z6PRikxkLxK5rEgJNR0gzzwhTUzLbIAD1OTI95W?=
 =?windows-1251?Q?qjhSed/HtmoUKX7ZDITexj/H+c74KvH5u/udqISkNDQ74+80bnO4mQFk?=
 =?windows-1251?Q?bPVJeCqY4NCecp9/9JQlU7RIA/hHfqytTMNNSinpr015puGBz9uHKGqJ?=
 =?windows-1251?Q?jw2OJ3ZXV6YFVyVkt+9hpokPzcw61IbnAGlugVGPK+glx3oIaw9kN241?=
 =?windows-1251?Q?UhcPo1cq0GWQjTqsvDyAFZRZSKVSXajNXQOCMUXYsaQkn6UbB0HqC9Vi?=
 =?windows-1251?Q?0heLZeTXQXlCdP3JCXz3Z5WEaUYqDQAs4jSJA6sUr61loZaXb2bC2Qy6?=
 =?windows-1251?Q?/gG4gJLqbRs20zMs/0kE45RYHiysFi2QkclpP8kj+8l7W4UrL0iwMaUN?=
 =?windows-1251?Q?Om/EQzi8Vvjt65RmfpA/+yrnXwtBrFK65RX6gVVtIoRJ9Xpj+thL3gTY?=
 =?windows-1251?Q?7Nf3rKuKtKIQTyIgaK2Vn9SlB7Jugb/vbvFVs44CvveukS/t0UJpq9VN?=
 =?windows-1251?Q?140On5qstOjk1tm/hf4mBNTE/7xSefWegHZICwcPLkBMmpBsNqB/7RIz?=
 =?windows-1251?Q?VwrKn7SQxf3PhP5iXHKWyntaDQDD7RB7M9pDjPpMbD8ine5kVArjFJY+?=
 =?windows-1251?Q?fhGfw1jsh2lK9TVTnV95kMoirgYki/RxxYkcaD/LI04yS/G4qICVeZyQ?=
 =?windows-1251?Q?DZjiAK3j+2xub9eNGlGYcQ5wc8NBlQ5PJt1v4BEAUa7bi05M+OSCFShD?=
 =?windows-1251?Q?7SEGiZE1wddkjvHK61/FWUaLD6kG0qWeTRgzpmpQF1GMvu7eFyvgdzxG?=
 =?windows-1251?Q?S9VFF1uGmOKgPKgb3807rhS6i0IuGNZuqENMr+nCThWu8AmwwZqPL5nz?=
 =?windows-1251?Q?1EIpCXGO2A7K5rLa8w/cx606SbRXjdDOWnvwzTQRC5p48Rt6lE5VAhhx?=
 =?windows-1251?Q?XC5twjIJXPhTwdlACCfrxy4CX8QUfJ8wJKM5j5mDLQOcGcWOkCJuJP47?=
 =?windows-1251?Q?GSxm2Z9Mvq7+aoHE+v7lhl58Weykerfl/0r/h3JtJOgpHgRbsz89LWpb?=
 =?windows-1251?Q?JE/oGGZenUhI3CEtSOJZAcEpvCP65CLEg4EhqN8PD/aSKYxe?=
X-Forefront-Antispam-Report: CIP:58.26.8.158;CTRY:US;LANG:en;SCL:5;SRV:;IPV:NLI;SFV:SPM;H:User;PTR:unn-37-19-199-139.datapacket.com;CAT:OSPM;SFS:(13230022)(4636009)(376002)(346002)(39860400002)(396003)(136003)(451199015)(40470700004)(156005)(32650700002)(40480700001)(32850700003)(7406005)(41300700001)(2906002)(8936002)(70206006)(109986005)(36906005)(82310400005)(6666004)(31696002)(35950700001)(8676002)(70586007)(81166007)(956004)(7416002)(31686004)(86362001)(498600001)(5660300002)(82740400003)(40460700003)(7366002)(4744005)(26005)(336012)(316002)(9686003)(2700400008);DIR:OUT;SFP:1501;
X-OriginatorOrg: myprasarana.onmicrosoft.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2022 13:58:58.3541
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e6700ec-9ecb-4204-10c4-08da9659453c
X-MS-Exchange-CrossTenant-Id: 3cbb2ff2-27fb-4993-aecf-bf16995e64c0
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3cbb2ff2-27fb-4993-aecf-bf16995e64c0;Ip=[58.26.8.158];Helo=[mail.prasarana.com.my]
X-MS-Exchange-CrossTenant-AuthSource: SG2APC01FT0064.eop-APC01.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PUZPR04MB6216
X-Spam-Status: Yes, score=6.2 required=5.0 tests=AXB_XMAILER_MIMEOLE_OL_024C2,
        AXB_X_FF_SEZ_S,BAYES_50,FORGED_MUA_OUTLOOK,FSL_CTYPE_WIN1251,
        FSL_NEW_HELO_USER,HEADER_FROM_DIFFERENT_DOMAINS,NSL_RCVD_FROM_USER,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [52.100.0.211 listed in list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5961]
        *  0.0 NSL_RCVD_FROM_USER Received from User
        *  3.2 AXB_X_FF_SEZ_S Forefront sez this is spam
        *  0.0 FSL_CTYPE_WIN1251 Content-Type only seen in 419 spam
        * -0.0 SPF_HELO_PASS SPF: HELO matches SPF record
        *  0.2 HEADER_FROM_DIFFERENT_DOMAINS From and EnvelopeFrom 2nd level
        *      mail domains are different
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.0 AXB_XMAILER_MIMEOLE_OL_024C2 Yet another X header trait
        *  0.0 FSL_NEW_HELO_USER Spam's using Helo and User
        *  1.9 FORGED_MUA_OUTLOOK Forged mail pretending to be from MS Outlook
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hello,

I hope you are doing well, and business is great!
However, if you need working capital to further grow and expand your business, we may be a perfect fit for you. I am Ms. Kaori Ichikawa Swift Capital Loans Ltd Consultant, Our loans are NOT based on your personal credit, and NO collateral is required.

We are a Direct Lender who can approve your loan today, and fund as Early as Tomorrow.

Once your reply I will send you the official website to complete your application

Waiting for your reply.

Regards
Ms. Kaori Ichikawa
Consultant Swift Capital Loans Ltd
