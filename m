Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A41F52297E
	for <lists+ceph-devel@lfdr.de>; Wed, 11 May 2022 04:16:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241053AbiEKCQN (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 10 May 2022 22:16:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229891AbiEKCQL (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 10 May 2022 22:16:11 -0400
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01on2137.outbound.protection.outlook.com [40.107.117.137])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A280850E22
        for <ceph-devel@vger.kernel.org>; Tue, 10 May 2022 19:16:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VszY8xSJugQH1RJTQUHTVt5m5qQjAeTyd2uIpb42cPp5ggKaqA6PD41ijktc68xfyBLXna2YFEuvVqLtx/yQn4RkwkCxZ4jGO5GdyJfiBUqNmDCBDkrMWWJ1JyYnUYUfjou3e1Ca+jlLj+OLo8UVg567ijiQCGL9Ljr16h9XncI7eJdfIL+/aD2Yr+Bkw2ZFQ8T2nmwrg1sF+IGILd3GwDICUSVJoc0pUGx0gLe9vyZ3d+3GtZZp1Xv9ii4JrWVgF7nD+YTat5AChQ+pV5x+4Vxg7f+OhG3SPoGL6Bbe4fOxawPPhzbVmmkM0GEZQDSeq1Wyx2Bh77ieZG0ciDTO3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yrIIxAevCnUlPGIqnd9qFbwBJURijYBYW+Vj7+jxt7U=;
 b=MhT+DYg6wzamAezgWEgDvp41j3QeExATddK5RBb2TeGYnE8HycLl5bZI1+o/mBEkobqFd2QSmZSoWX6iICqClmj+Elv5I6abyMDK/EC6pm3MWiUTw0mfOwTPJobLQ/+c6GfVap7Hu1ZKOdZ0NELl4bh1zIpYd1CIsuznYrVvSuUXqaJEbsB5gA0CDfec9wXxzCiFLuWtZCST9SHTVAmmB7hPBiaktIAW3jZJe7YpcgulV36BtfZ/ECJ2M3pbrTOGz114zJGbKtd8FU65CVccAY8t2RGWF9weHFw60mf6mjquLz5OJOEFjuMNVOp52D6rk0yTeyx9RbjGz761IA96mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cybozu.co.jp; dmarc=pass action=none header.from=cybozu.co.jp;
 dkim=pass header.d=cybozu.co.jp; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cybozu.co.jp;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yrIIxAevCnUlPGIqnd9qFbwBJURijYBYW+Vj7+jxt7U=;
 b=7FtOJVNXHfpYWXjvMPFAxNB1sLhuifJtURDqEATnIhrXPwgpTLonfZAyCVMXkH8hg8atZzqVBxvth1KIc78egUcDZrt1RGDOfTgtdAx+UNnjIcnt/TPJ8TI/yTC8y9pPddldVEUUKzGt42LtcDJM6R+nGbn+ogLIW+ETDB7SlPA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=cybozu.co.jp;
Received: from TY2PR03MB4254.apcprd03.prod.outlook.com (2603:1096:404:b1::17)
 by KL1PR0302MB5347.apcprd03.prod.outlook.com (2603:1096:820:4a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.12; Wed, 11 May
 2022 02:16:05 +0000
Received: from TY2PR03MB4254.apcprd03.prod.outlook.com
 ([fe80::3199:64a3:1b02:5465]) by TY2PR03MB4254.apcprd03.prod.outlook.com
 ([fe80::3199:64a3:1b02:5465%6]) with mapi id 15.20.5250.012; Wed, 11 May 2022
 02:16:05 +0000
Message-ID: <51cf4cbb-3e2c-4a51-9c03-eea7cf7378e8@cybozu.co.jp>
Date:   Wed, 11 May 2022 11:16:03 +0900
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH v3] libceph: print fsid and client gid with osd id
Content-Language: en-US
From:   Daichi Mukai <daichi-mukai@cybozu.co.jp>
To:     Ceph Development <ceph-devel@vger.kernel.org>
References: <e0e8f5e9-d2fe-bbd6-e115-abe3ea1066e1@cybozu.co.jp>
In-Reply-To: <e0e8f5e9-d2fe-bbd6-e115-abe3ea1066e1@cybozu.co.jp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: TYAPR01CA0022.jpnprd01.prod.outlook.com (2603:1096:404::34)
 To TY2PR03MB4254.apcprd03.prod.outlook.com (2603:1096:404:b1::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d3e5fd29-cc91-4985-98b7-08da32f433ca
X-MS-TrafficTypeDiagnostic: KL1PR0302MB5347:EE_
X-Microsoft-Antispam-PRVS: <KL1PR0302MB5347D0C192A5E8E4E7ACBC1EACC89@KL1PR0302MB5347.apcprd03.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bHYh02popdCu1yGPfF5tq72c+ozhs+zltCdXO0vI5TngumgJj3YxcHN9kq8A1UZpLYJJPjg4zTyXJXfS6HhRM9GfXF1908qBjxESGyaSXbyICv2OngmXxw5ieSIOPcx3pdFlzxur1JnbNITkiZfUlYhhshzL/fZ7gTYVeTQG8Zxqpz1I89BEvhURUL8Qypd0hZlKKGLNkzsgDuYg5+jMYRdZ7Bbasyie6AVfYSlHgYz3EO11g9CPp1I1FL7mKhRovRL/sDH4CDIu7+m26VDaysxiKhnzItsEaiQmTik9rRd08WfMAoNbL5N1++LX25/7y88QsINTszIoEQsfMbLTqSsn0Ctthgml86o+f2bYvLWr/DBGQbFfdokP2dDFwNZugd7754Mj1Ox1TEi+/vcCCtsbPb/6um+g2QPk93lvxEFRBNmb3SpOynnevmgN/E8PSyEreA/sW647g6LkFVvkWoUDQfWFty1SH3BHEWj54wVz+Vcip35u+zSWiFsv+ThEQ5xvxlSuP2Ts/LaFgCPUDsz1xQlRVruoKtkkMMu3Pi84wzdY0ooPxHiBQAzH4RfY+VAt1/EiSmB05mCCf7IXUG/MP2dYM1Ogp6Od457Zkv/KDLvyxEPw764agcKhgV1NG1y/HDICt6VlROtzMK9KKd/LlOOYZVzBFiMgLdx/d0MfMTEXjS6Ere+O/J8rMZ4muQHGHSbaFwWtd8nqeN4ASqKnlcJc8vMWTzNryBgw7FQ1pYe9hCFsxiWbvqpvls8v8cSG4prDAfcUaHFFzEIAz2fkzyYH231VU0mfZfv32UPIBHOHBZQrAUiK3l8Vv7jC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY2PR03MB4254.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(66946007)(36756003)(66476007)(8936002)(66556008)(38100700002)(83380400001)(26005)(5660300002)(2616005)(6512007)(8676002)(31686004)(53546011)(38350700002)(6506007)(6916009)(86362001)(508600001)(31696002)(52116002)(6486002)(2906002)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UXMxZXpBSFRtN2lvS1l0YVVSdlFOS01hRENQQ2MvbzQ3RWZINUVML056VGhy?=
 =?utf-8?B?WlEzbGVKR0gvOW5MaTlkdGIxeE1TWngwZHM0SmpRVUxTa1NtazdlQlJpbHlx?=
 =?utf-8?B?blkybVdJaGlBbnJFSXl5VWlYNUJkWmpIL2FTRjRvQ3FncmdwbE1IY0liZjI0?=
 =?utf-8?B?dzNVSWQ0Y1RzQU1zc0hqS3dDNllQdHFNVjBwSk1pQkdKVXNZMitubU8yR2tW?=
 =?utf-8?B?aUp4TTRONFRUZ1k4a290RytOKzFjZ3JobDkzVEZ2UUZPbUtmRlA2WFcybGJ3?=
 =?utf-8?B?VHBkRVVqZEVweUl2VEFuUHZDNHpVUG5xc24yMkRBME1Celo5KzBwdG42OXVS?=
 =?utf-8?B?dXpmUDlRelpRRExnZjVTbm4yK2R1QkhUUzg2d2xiczgxMkFzZ0x3aHMxcUM5?=
 =?utf-8?B?UDFka3dqY3hmZHJiMjRVeGJ0ZUNCNnAzMjUxTmtuSVd3eFZVM0M1bXJBd1NV?=
 =?utf-8?B?SENkMmIwd2ZGSy96OXhMVGVKUUJkOW03YkZOWEJBVWRTY2R1WkxHaVdJQlVy?=
 =?utf-8?B?OThvWGdNUlREVXMzSFlVY0VmUWpVMmpTcGFTUDRWN01idGdhRFNkbXBHK2Jj?=
 =?utf-8?B?b3pmdnJ1bEo0blF1NktpNEZuYytjdDJMbStXdjYyYWxHdVNDVTc3SWZDUWRU?=
 =?utf-8?B?SWJORm1tRDN0WHU5bUhyMzNCQU1iZDd4aTZYa1Zob1NnNGRldnMxZEFWWHVB?=
 =?utf-8?B?cGtXbE01SkNxSzZ6MXc4RSswMkF0ZVdjYS9PcTFlaTI3L3BJd3VQTkJ2ZkNT?=
 =?utf-8?B?NVZuOGxTUXJ1Y01vbjJsN3Bkc2hWUUNISURzdm1kNWcvbnovQXRWUHY0OVo0?=
 =?utf-8?B?MGRvUTc4ZS9FaVdtRWFPNWROZmo1bGNMR21DZzdMSDRRbDZvZ3k2UngzSEFo?=
 =?utf-8?B?SHMrL2ljcVA4bysrRkNHemVyalFOS0QrQjdlbzB4T3pYT2RRd0U4VEwzc0NR?=
 =?utf-8?B?R1Q1TkR6dHVENGRIaUR2MU1nWDE2TG9WU0ovN1lDMFZCWlgrUWQ4ZUkrL3Vs?=
 =?utf-8?B?UmI4SWpmRGhETlkyNnlWZW12cWpKUjRwcno0M3F4ZlRCR0FhODVEdmlNNzdw?=
 =?utf-8?B?OEVaYXdTZ2R4bUp4c3c4RnVQSzdBU0o3d2tuSlJtd2JwNEc4SDArbHJzeVRh?=
 =?utf-8?B?SGVDYnlIZ2I1SUtqQXpOVUtMUDM5SGdYbm5QamcwcXJxMks5ZnU3dVNrZGsr?=
 =?utf-8?B?cU4rVkJCNDFZNTFyQlhBVHNZWldwMUMwcHFFRWhrUEtzRkJxZWV0cmY1ZjBy?=
 =?utf-8?B?UFF4R3U0blg3dTlicUkwWUo4eHJ3TWZzc29YNVlpZzJ5S3ZEZ1hCM2RTaUNH?=
 =?utf-8?B?SlhMZS9YVXkzSGROWFQzc1BUbmJSM3NRc29CelplMVpBN0U0Z1hwSE50T25z?=
 =?utf-8?B?dDdKTkZ4SGlzS0lmZnRodi9OOWxxQkhNMHQ3OTlncWM2QncyVDVGWUZyZ21u?=
 =?utf-8?B?Y1BIaTgxOEVaRmk0UUdLUlpYaFR0S25ZOGFpU3Fya0h0R2dWRU5ER0lLUkdX?=
 =?utf-8?B?a0RNZTl0allMVnlrZnVFQzhXVG5HQWZOSTBKeklNVDFkYlNrNGYxS3AxeldO?=
 =?utf-8?B?N0gxSkozb1JNQVpnVTRYSGd6SUFuSE9IdEJ5bHFFeXAzZ3l6TENrR0lKQ0p3?=
 =?utf-8?B?U3duYlN5UXk2eStiazArVURzQjFDYUVZYmJ6c0hLSjM2dzZ2RmZ4Ky8xNWxH?=
 =?utf-8?B?QlFtRGFzM2VOb2o5VXdtbjdxUVZ6VVRtSmlmY2ZPM3QvaWIrZFhQM3dFaGFN?=
 =?utf-8?B?bkQrd3Z6eUxZS2NwaFdlakJMcllOS3JEL0dyaWJ2UUlCQ1RzTnkzY01lTDZn?=
 =?utf-8?B?aEt4RUxTV3A5R2FNT0h0S2w3L0k5emJBQVM0dWNKdU03MTZRbWFIaUNPcnZr?=
 =?utf-8?B?d0QvTGQ2djJUTUdTVUJZcFY1eU94em5yTExZU0ovNnhNQXFtR2ZoZWp0Yms3?=
 =?utf-8?B?T2xseFZLYWc3UjJvYVp6RUZCV2tWNDZrN2FsdUp4YWNaTVh0U29vMXJkeEVD?=
 =?utf-8?B?OElVMmF0aytSR2g5K3p2eWFmc0diWTBDWU5Gc21oOFBlMVF0MUdXSlVSaUIv?=
 =?utf-8?B?UUFwRkNNbE91YnpEaGdWczYwMWtwMFdFRnNhMldsdTE0bXI3UDloOHhkT3BZ?=
 =?utf-8?B?OFJKUVJQaTZuWG9HNGdlWUVJaGw5QnhHWWo4RFRlbW5sNmI4bFcva0RlL01v?=
 =?utf-8?B?clJOYzBEQndQZldGYTB5TkhGMk9VRksxako5M1VxNWxHSXY4ZzZxSUtIbVZ6?=
 =?utf-8?B?L21wbmVlWkhqMU1DbHJraEZhZ3IwZ0JrUkYxQzk0bTgyMEhIQmVvMzJXcTZM?=
 =?utf-8?B?MGU0dHRjZkRuYkVUMkw1NDFMazZiSWNlODN1WjdRNVM5UlBFeXRNc3drTUpZ?=
 =?utf-8?Q?e5aDrbiEgHUfpFO6+aaEPypKu35Cs4RxUHAE4?=
X-OriginatorOrg: cybozu.co.jp
X-MS-Exchange-CrossTenant-Network-Message-Id: d3e5fd29-cc91-4985-98b7-08da32f433ca
X-MS-Exchange-CrossTenant-AuthSource: TY2PR03MB4254.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2022 02:16:04.9920
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3761f390-05f7-4386-9a0b-b6806c13b841
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0DciC46nb+ltkhQ5lbAizWGcMhiniMpRojo89L+c7AlFgmU+H08L/V7lYwGiPjGNnSZpHBs/8xdZvldy5xGFzmbeJDtAmFO5tQDguk0WUDQHk9Ca61hVOVPoO8VBaYfG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR0302MB5347
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2022/04/26 13:59, Daichi Mukai wrote:
> Print fsid and client gid in libceph log messages to distinct from which
> each message come.
> 
> Signed-off-by: Satoru Takeuchi <satoru.takeuchi@gmail.com>
> Signed-off-by: Daichi Mukai <daichi-mukai@cybozu.co.jp>
> ---
>   include/linux/ceph/osdmap.h |  2 +-
>   net/ceph/osd_client.c       |  3 ++-
>   net/ceph/osdmap.c           | 43 ++++++++++++++++++++++++++-----------
>   3 files changed, 34 insertions(+), 14 deletions(-)
> 
> diff --git a/include/linux/ceph/osdmap.h b/include/linux/ceph/osdmap.h
> index 5553019c3f07..a9216c64350c 100644
> --- a/include/linux/ceph/osdmap.h
> +++ b/include/linux/ceph/osdmap.h
> @@ -253,7 +253,7 @@ static inline int ceph_decode_pgid(void **p, void *end, struct ceph_pg *pgid)
>   struct ceph_osdmap *ceph_osdmap_alloc(void);
>   struct ceph_osdmap *ceph_osdmap_decode(void **p, void *end, bool msgr2);
>   struct ceph_osdmap *osdmap_apply_incremental(void **p, void *end, bool msgr2,
> -                         struct ceph_osdmap *map);
> +                         struct ceph_osdmap *map, u64 gid);
>   extern void ceph_osdmap_destroy(struct ceph_osdmap *map);
> 
>   struct ceph_osds {
> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> index 1c5815530e0d..e7c01fcc1d16 100644
> --- a/net/ceph/osd_client.c
> +++ b/net/ceph/osd_client.c
> @@ -3920,7 +3920,8 @@ static int handle_one_map(struct ceph_osd_client *osdc,
>       if (incremental)
>           newmap = osdmap_apply_incremental(&p, end,
>                             ceph_msgr2(osdc->client),
> -                          osdc->osdmap);
> +                          osdc->osdmap,
> +                          ceph_client_gid(osdc->client));
>       else
>           newmap = ceph_osdmap_decode(&p, end, ceph_msgr2(osdc->client));
>       if (IS_ERR(newmap))
> diff --git a/net/ceph/osdmap.c b/net/ceph/osdmap.c
> index 2823bb3cff55..cd65677baff3 100644
> --- a/net/ceph/osdmap.c
> +++ b/net/ceph/osdmap.c
> @@ -1549,8 +1549,23 @@ static int decode_primary_affinity(void **p, void *end,
>       return -EINVAL;
>   }
> 
> +static __printf(3, 4)
> +void print_osd_info(struct ceph_fsid *fsid, u64 gid, const char *fmt, ...)
> +{
> +    struct va_format vaf;
> +    va_list args;
> +
> +    va_start(args, fmt);
> +    vaf.fmt = fmt;
> +    vaf.va = &args;
> +
> +    printk(KERN_INFO "%s (%pU %lld): %pV", KBUILD_MODNAME, fsid, gid, &vaf);
> +
> +    va_end(args);
> +}
> +
>   static int decode_new_primary_affinity(void **p, void *end,
> -                       struct ceph_osdmap *map)
> +                       struct ceph_osdmap *map, u64 gid)
>   {
>       u32 n;
> 
> @@ -1566,7 +1581,8 @@ static int decode_new_primary_affinity(void **p, void *end,
>           if (ret)
>               return ret;
> 
> -        pr_info("osd%d primary-affinity 0x%x\n", osd, aff);
> +        print_osd_info(&map->fsid, gid, "osd%d primary-affinity 0x%x\n",
> +                   osd, aff);
>       }
> 
>       return 0;
> @@ -1825,7 +1841,8 @@ struct ceph_osdmap *ceph_osdmap_decode(void **p, void *end, bool msgr2)
>    *     new_state: { osd=6, xorstate=EXISTS } # clear osd_state
>    */
>   static int decode_new_up_state_weight(void **p, void *end, u8 struct_v,
> -                      bool msgr2, struct ceph_osdmap *map)
> +                      bool msgr2, struct ceph_osdmap *map,
> +                      u64 gid)
>   {
>       void *new_up_client;
>       void *new_state;
> @@ -1864,9 +1881,10 @@ static int decode_new_up_state_weight(void **p, void *end, u8 struct_v,
>           osd = ceph_decode_32(p);
>           w = ceph_decode_32(p);
>           BUG_ON(osd >= map->max_osd);
> -        pr_info("osd%d weight 0x%x %s\n", osd, w,
> -             w == CEPH_OSD_IN ? "(in)" :
> -             (w == CEPH_OSD_OUT ? "(out)" : ""));
> +        print_osd_info(&map->fsid, gid, "osd%d weight 0x%x %s\n",
> +                   osd, w,
> +                   w == CEPH_OSD_IN ? "(in)" :
> +                   (w == CEPH_OSD_OUT ? "(out)" : ""));
>           map->osd_weight[osd] = w;
> 
>           /*
> @@ -1898,10 +1916,11 @@ static int decode_new_up_state_weight(void **p, void *end, u8 struct_v,
>           BUG_ON(osd >= map->max_osd);
>           if ((map->osd_state[osd] & CEPH_OSD_UP) &&
>               (xorstate & CEPH_OSD_UP))
> -            pr_info("osd%d down\n", osd);
> +            print_osd_info(&map->fsid, gid, "osd%d down\n", osd);
>           if ((map->osd_state[osd] & CEPH_OSD_EXISTS) &&
>               (xorstate & CEPH_OSD_EXISTS)) {
> -            pr_info("osd%d does not exist\n", osd);
> +            print_osd_info(&map->fsid, gid, "osd%d does not exist\n",
> +                       osd);
>               ret = set_primary_affinity(map, osd,
>                              CEPH_OSD_DEFAULT_PRIMARY_AFFINITY);
>               if (ret)
> @@ -1931,7 +1950,7 @@ static int decode_new_up_state_weight(void **p, void *end, u8 struct_v,
> 
>           dout("%s osd%d addr %s\n", __func__, osd, ceph_pr_addr(&addr));
> 
> -        pr_info("osd%d up\n", osd);
> +        print_osd_info(&map->fsid, gid, "osd%d up\n", osd);
>           map->osd_state[osd] |= CEPH_OSD_EXISTS | CEPH_OSD_UP;
>           map->osd_addr[osd] = addr;
>       }
> @@ -1947,7 +1966,7 @@ static int decode_new_up_state_weight(void **p, void *end, u8 struct_v,
>    * decode and apply an incremental map update.
>    */
>   struct ceph_osdmap *osdmap_apply_incremental(void **p, void *end, bool msgr2,
> -                         struct ceph_osdmap *map)
> +                         struct ceph_osdmap *map, u64 gid)
>   {
>       struct ceph_fsid fsid;
>       u32 epoch = 0;
> @@ -2033,7 +2052,7 @@ struct ceph_osdmap *osdmap_apply_incremental(void **p, void *end, bool msgr2,
>       }
> 
>       /* new_up_client, new_state, new_weight */
> -    err = decode_new_up_state_weight(p, end, struct_v, msgr2, map);
> +    err = decode_new_up_state_weight(p, end, struct_v, msgr2, map, gid);
>       if (err)
>           goto bad;
> 
> @@ -2051,7 +2070,7 @@ struct ceph_osdmap *osdmap_apply_incremental(void **p, void *end, bool msgr2,
> 
>       /* new_primary_affinity */
>       if (struct_v >= 2) {
> -        err = decode_new_primary_affinity(p, end, map);
> +        err = decode_new_primary_affinity(p, end, map, gid);
>           if (err)
>               goto bad;
>       }

Would you please review this patch?

Thanks,
Daichi
