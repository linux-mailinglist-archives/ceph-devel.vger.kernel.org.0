Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A36D254C487
	for <lists+ceph-devel@lfdr.de>; Wed, 15 Jun 2022 11:22:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244312AbiFOJWP (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 15 Jun 2022 05:22:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239815AbiFOJWF (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 15 Jun 2022 05:22:05 -0400
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01on2135.outbound.protection.outlook.com [40.107.117.135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A44FD38DB7
        for <ceph-devel@vger.kernel.org>; Wed, 15 Jun 2022 02:22:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bh90vLwRsVUMFEp2vjIIwnNDUgZXSDKFSPKiCR0gHwZrU4ExHrE+Rb2NTENBd2hb+j6sZRMYCDQRlfewEaNwHMXDHPzWveSNjdf5Y7anAkzShLxPDyYhvE73CWX0pTSE7a41kVYLhl+IB0RJPphaXh7sFB9KzuT8Bbg/fO2H365DcoLLrElnXw8IVE5pjxQbMMuhiRq13BfZLC6ZJpdfP/rF6EnLzjQFWLhQZa+j2m3vEVsO61oTBULNmc/FVWfkY6MTOeB2VX3A+Qmp8r90DU490Kn9T5JdFc6L53WMoSY3dVVbo1eDrKGqEm1C7iuPCtvx+GuxVmX5eh/YIGwbfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uF3nxqWnVGZeKswsD/GYG6fWVqKiC1qeQnK9bGdC+zY=;
 b=VQ8BDgZA7EZXZmP1FfJW3t9itDerVuRUDwGSflgWSTTi7i2QxlGo9u/OE1+rmNcKEI18tCKa3imtVrn9I2Rct0SMr1nwJWf7id6A7MD4YRySeqVpbtzBRXvwCgfywiByTE2/Q+P3VWSYnnJaeLTHB7eXyxgoGVhM/tZUMRdRnH/PiYV5jCm9hDob/DGqaf3QQZoqA2UKdtW0GAKX7RE1Khca3Co/p+/mCwFcC1bEuaTbglDsHy9q06dcKLqheURpG67/zmdivvUDRhhMcKdCRWb/sh189cYeT2AXsUKnxn3j0Kkr6Yk/LxJdL+MJnmhrjgp9T6FeUNx68wqQeqJ+Ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cybozu.co.jp; dmarc=pass action=none header.from=cybozu.co.jp;
 dkim=pass header.d=cybozu.co.jp; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cybozu.co.jp;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uF3nxqWnVGZeKswsD/GYG6fWVqKiC1qeQnK9bGdC+zY=;
 b=Ks/bvIHWONiwaSYSI/rTEBiRNklr+o98bzhbImgxATqUbQcTF3J4PdQ9Qe/iVpPbKLiwu7arj43XRX/p2Z5qwF85Q/Bi+5unFELNfPbNw0vgeMRSxTj/BpybeuU74ZoS9dmgzk0qUsupaelJgLLgmUR+cTKyyFhva52cRwCVy8I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=cybozu.co.jp;
Received: from TY2PR03MB4254.apcprd03.prod.outlook.com (2603:1096:404:b1::17)
 by SG2PR03MB5086.apcprd03.prod.outlook.com (2603:1096:4:dc::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.12; Wed, 15 Jun
 2022 09:21:59 +0000
Received: from TY2PR03MB4254.apcprd03.prod.outlook.com
 ([fe80::3199:64a3:1b02:5465]) by TY2PR03MB4254.apcprd03.prod.outlook.com
 ([fe80::3199:64a3:1b02:5465%6]) with mapi id 15.20.5353.008; Wed, 15 Jun 2022
 09:21:59 +0000
Message-ID: <642ae23f-c941-6ef9-8a0c-68c6bbaff6ae@cybozu.co.jp>
Date:   Wed, 15 Jun 2022 18:21:56 +0900
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.10.0
Subject: Re: [PATCH v4] libceph: print fsid and client gid with osd id
Content-Language: en-US
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>,
        Satoru Takeuchi <satoru.takeuchi@gmail.com>
References: <bfc20d2c-9198-2cb3-506a-4bae09c6cd68@cybozu.co.jp>
 <CAOi1vP9rrmWr7oyy1U_M+x6NSFeQWBZacBEooFgdKXYETVLJ6Q@mail.gmail.com>
From:   Daichi Mukai <daichi-mukai@cybozu.co.jp>
In-Reply-To: <CAOi1vP9rrmWr7oyy1U_M+x6NSFeQWBZacBEooFgdKXYETVLJ6Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TYAPR01CA0196.jpnprd01.prod.outlook.com
 (2603:1096:404:29::16) To TY2PR03MB4254.apcprd03.prod.outlook.com
 (2603:1096:404:b1::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0098d9c7-7834-457c-6b5d-08da4eb07f97
X-MS-TrafficTypeDiagnostic: SG2PR03MB5086:EE_
X-Microsoft-Antispam-PRVS: <SG2PR03MB5086204BE3C1256F7B64030EACAD9@SG2PR03MB5086.apcprd03.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J6ySexaevq+2x9DLcBLTJZba0ssfBTeDXobjs/XuGXBOAhLrBlu6EVUKMfLXSWBrAcvLxR29wzNfJGyLkIi3wOLKkjVQF+kb4b8ycF6vWth7CdFog38eYvHRc+ImYXx5rMB1Xp9kijYsOfeA3UbUAdKDO5bQLLfmGVTdQWX5CpZep7rBKikFJu/wPX25VGxguXr6IOLQ/paZ15D0Udp4EUCBDz4dteKlRcxuvW0S8wgWpzAQJb4Wx6O5oCQl9UxasNJugV+VmHb6ebZevrw187mySC+XMnqTcAyVtQHhUFGM8mMLbR4rTzwYsIyGLJfwdY2rh146khT+nsO7qsD8dTszNGLOgqGn8u6M34RHluoK1QuomhyGX3uavJsj7Dd3NUOf/Zv2ta/F9S9khdi6v3glza6YyLwm8ZnHbA4ffR7yMdnzOOPiVz3VIDhJCxvEID9iuwIC9eTFqZZhRAO77hZjPWl/CetpwmFIYsJVvOja75rnZ+eiO2A/9dJAUQFCwf3VziO+nSSWbL7sKg7jlewMVEnSVVz7zhhOjafecmH9FSxbB3tUkJ/PGJzbIZVe2HCN1HH0hGaCQKSQY6i/jW00wEubhMYpEGg5PItJGSUHObrEv3K0asLayxnYJr8qW6z4/1xJ+kWM8NVeWuWWgjmTezNQ19PJVqATFL0SJy87KdrQBVDmQi5ANJCz/DYJhBM2y2/1QpEoq1wZBCw2ctp0HPMYSBH+F07kLRjsV1QPc2B1Is66bdDYDktkeC+xEVdYACOZlJRAFaegiNYk83QKjuv039Qe1GwBIEPx7CuM3SD8tdYizEQMYPfK7KfmsDQcT74BmgGrM8WOJaADcw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY2PR03MB4254.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(2616005)(31696002)(26005)(6512007)(86362001)(38350700002)(38100700002)(6666004)(83380400001)(186003)(53546011)(66476007)(36756003)(4326008)(66556008)(5660300002)(52116002)(316002)(31686004)(508600001)(6916009)(2906002)(54906003)(6486002)(8676002)(66946007)(966005)(6506007)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MDZYbXRaZ244ZmtYVko2RitWUmwyYmM1OFRWZ2poMnorL0E4NjhCMVNqaU1K?=
 =?utf-8?B?U0UwbkcxZi9TOTBqMUgwTVM2YnNCNXZKdVNaL1VWVUIxQlFLTWRIaDdSNzJ5?=
 =?utf-8?B?U1E0YThGUldWR2xuZHpta292WUR6bTN1d004ZkZ2RFgzMVduUmhJeC95RjZ1?=
 =?utf-8?B?Q2JIRUJNai9oTXg3Y2FrbUY4eHRmcUJ4ZmRjZDBUMWV3VHJtMVViWW1NSlFx?=
 =?utf-8?B?RzBtRFpHOUN4elhxS1QvUDByWko0REI2eDZ6TFdOTE9FcW5TaTRwSC82ZWRU?=
 =?utf-8?B?ZWZKMGVXa05FNW4zdDJTMkRsZVRWSGZwTFh1b2xxWnpuMFhWTHFhNTc4WjAw?=
 =?utf-8?B?OW85RWJDaUhZM1lrMWtTSEVHY2E1SWJIblljTzhlNmgxSHFDajdJWGZJbEk0?=
 =?utf-8?B?Mmhla01nTCtNTkxxWjV4Q3I0emd0NTFmK00yRTlCcTRKUkc4UHVWeTJrVUdQ?=
 =?utf-8?B?aC9tbG9KZmJkQkpXM2hlTHJnQm9tV3A5MXhhbGRlMEpWenBWcGJYQnB2enhJ?=
 =?utf-8?B?cFlteGxDT0hIaXMxUnBtNi92L2l5Rmd5SnVQQ1RJNlJvWjM1OHRhMjdRaWVl?=
 =?utf-8?B?SC9QckcwOXVJb1lLbVdqNDl1N3pKTEdyUkhFODVsdXk5YjExdUpybzIvRktk?=
 =?utf-8?B?L29yNWRUSEkzZmdtZ2p5TzlHVWxCVVBUVlVzeGxpY1JJTTBEMmJSRWtQWitE?=
 =?utf-8?B?c0wxSzV1OU9ldW53d3Qva2lZc01DQkpwcHJOWnNOUmNUTmlEWk5OdU5kNzZx?=
 =?utf-8?B?cDVTa0ZWYStQWFhyc1dTUGp1ZjZWOFJGdUtMWVVCOWdHU09Cc0M5U3ozMlp4?=
 =?utf-8?B?YStlTVM0bzcrUVZUMjhOZGpNMUpBNEFHZUZzUDFrOHVjQUEwUERjc1lMbHhx?=
 =?utf-8?B?eUpRdzc3LzVOVXozMGFzb0kvNGN5M0h6Zm1BNmhQZUFNOFU2aFFia1BmdU5O?=
 =?utf-8?B?Q2pCaEdKMVF2RHlzdGxwd2F0K3lVUkMzNHhzeHVuZnQwcThzNVlWNUt4L1V6?=
 =?utf-8?B?SWRReG9BellybTkwRlJYYUJzcUJzb2dsK0tTT2lTRktWWjR0aXVjQ1RSUVJs?=
 =?utf-8?B?Nk1QYVVQd2F1NGxiL3BDc0Y5MGxDVXk3Y292NUd3SDVKZ0xRdUIvWlFycWxi?=
 =?utf-8?B?elhOOG4wcXZPd2VIZTNUS3Qvam11bnZhbjhUcDJxK0hKdVFsU2JMZnBKL1Rt?=
 =?utf-8?B?SWU5emN5WmlranIxSzIzTFNISk56UHE2SEdOYTJodVhySnViWnpnMmdYUWd6?=
 =?utf-8?B?a0lHbjhsNGs5QjFXNFYxdThyR3c5bHQ1dzZub0tVTDR0YllVSlNRWHJ2ZkRJ?=
 =?utf-8?B?NUltWFN4ZWx5V2pZamtwNXlJelBER2NseHNpYlFWcHpSN24vZzl2K0R0RGhZ?=
 =?utf-8?B?Myt2ZUxsY3RNb3BpMlJwL3ZpS2grUkJocktvaEM1VTZIRjMzdVRYQi9VdHFk?=
 =?utf-8?B?YU9BVDRhcFRBSHd4K052QnBQdStxOTQ5NkZ3Sit6bnNBYTh4TllDT0FJck1r?=
 =?utf-8?B?TXEvSkVoQ2syM1hONU05QmVwVUpDUmRNOXZKRVZwbDZPd2h6S0I1Y3E4c3hN?=
 =?utf-8?B?Q1ltRlo0NkQ0M2dJbWN1bG50WHhMZDBidGVaKzBUUjdlazN2cy9uTWVIcTMw?=
 =?utf-8?B?TWZ1dTVYNEJFRXpLUkhENFJkbk1EK29ESTh4M2ROMEFUS3p5MVI0TWJkOU1I?=
 =?utf-8?B?Y1Z3Y2Jud2F4djNlSzhEZmYydVpZRVBZV0EvZlE0eE9UU0phTi9ja0psN1I2?=
 =?utf-8?B?MzQ0eW9Ia1I0TEpGZGhvYlNGbEM0eXNLaVFneGcybjl0Vm1uNjBVOW9kWDZh?=
 =?utf-8?B?MSt3UUFDQ05vaHBidmFpMmFhUFdzS2FLZnE0WXBQNjRhRXpxbnhkTG1lTWdj?=
 =?utf-8?B?V0tmclJ3NzArQloxMHY2RUxrL3liaTVOaCtFSUhEU0pjVmp0bi9zZ3dDVU41?=
 =?utf-8?B?ODBIS0tsb1VnOWttUjNpdHBGVkxRRENjblpjVi9OQTk5VVU5anhpb25iQkhw?=
 =?utf-8?B?Y3NDU0pPNUhZQUdwd2NFdTdsVG9iN0F0dDJmcHhEdWlZZWU1NFN3Yi9obnRo?=
 =?utf-8?B?eTVyMERPRG9FZGpVTWNlaDBDMzRQTnVKUTRiZlo0alZRNnpEU0U2bjVzeGRI?=
 =?utf-8?B?UnJ5OXF3YzNHdlkrQzdDTWdPbitUeHB0RTI2VDJISVB0L3VmRVQ1V05raTVJ?=
 =?utf-8?B?TGRQdHo2Nzc4dTJ0TzhvaVFSL0Z0Z1Q1M1VDVXFCYTFiSG1iSzdFdThsNlJ2?=
 =?utf-8?B?VHZFd0NhcUJyTEd6QnBiYkd1SUR0SWtNWnI2YitETGFSL0RiMFhubFhiL2NI?=
 =?utf-8?B?WVVIMThoeldkdW5xZVcrb1pody9ZSDI3WE4yNWtBRkh6NlgvZWtvSVpweDlz?=
 =?utf-8?Q?TaUW108nbKJcG8DGZf8lzgFHajgXrM0R/Su9U?=
X-OriginatorOrg: cybozu.co.jp
X-MS-Exchange-CrossTenant-Network-Message-Id: 0098d9c7-7834-457c-6b5d-08da4eb07f97
X-MS-Exchange-CrossTenant-AuthSource: TY2PR03MB4254.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2022 09:21:58.9907
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3761f390-05f7-4386-9a0b-b6806c13b841
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TC5oFCSrUgUF+eLt3IrgeNOVAiONgM17GsSxzgThOEJY870jZ65O4WX9W1cQLUwd6c3KLYmmqeq+L2cC1cmw8MOlKwuNIZxfYfC2Jie37E5YPKviLIjRex9EBSCwS8Sd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SG2PR03MB5086
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2022/06/14 22:12, Ilya Dryomov wrote:
> On Mon, Jun 6, 2022 at 8:00 AM Daichi Mukai <daichi-mukai@cybozu.co.jp> wrote:
>>
>> Print fsid and client gid in libceph log messages to distinct from which
>> each message come.
>>
>> Signed-off-by: Satoru Takeuchi <satoru.takeuchi@gmail.com>
>> Signed-off-by: Daichi Mukai <daichi-mukai@cybozu.co.jp>
>> ---
>>    include/linux/ceph/osdmap.h |  2 +-
>>    net/ceph/osd_client.c       |  3 ++-
>>    net/ceph/osdmap.c           | 43 ++++++++++++++++++++++++++-----------
>>    3 files changed, 34 insertions(+), 14 deletions(-)
>>
>> * Changes since v3
>>
>> - Rebased to latest mainline
>>
>> * Changes since v2
>>
>> - Set scope of this patch to log message for osd
>> - Improved format of message
>>
>> * Changes since v1
>>
>> - Added client gid to log message
>>
>> diff --git a/include/linux/ceph/osdmap.h b/include/linux/ceph/osdmap.h
>> index 5553019c3f07..a9216c64350c 100644
>> --- a/include/linux/ceph/osdmap.h
>> +++ b/include/linux/ceph/osdmap.h
>> @@ -253,7 +253,7 @@ static inline int ceph_decode_pgid(void **p, void *end, struct ceph_pg *pgid)
>>    struct ceph_osdmap *ceph_osdmap_alloc(void);
>>    struct ceph_osdmap *ceph_osdmap_decode(void **p, void *end, bool msgr2);
>>    struct ceph_osdmap *osdmap_apply_incremental(void **p, void *end, bool msgr2,
>> -                                            struct ceph_osdmap *map);
>> +                                            struct ceph_osdmap *map, u64 gid);
>>    extern void ceph_osdmap_destroy(struct ceph_osdmap *map);
>>
>>    struct ceph_osds {
>> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
>> index 9d82bb42e958..e9bd6c27c5ad 100644
>> --- a/net/ceph/osd_client.c
>> +++ b/net/ceph/osd_client.c
>> @@ -3945,7 +3945,8 @@ static int handle_one_map(struct ceph_osd_client *osdc,
>>          if (incremental)
>>                  newmap = osdmap_apply_incremental(&p, end,
>>                                                    ceph_msgr2(osdc->client),
>> -                                                 osdc->osdmap);
>> +                                                 osdc->osdmap,
>> +                                                 ceph_client_gid(osdc->client));
>>          else
>>                  newmap = ceph_osdmap_decode(&p, end, ceph_msgr2(osdc->client));
>>          if (IS_ERR(newmap))
>> diff --git a/net/ceph/osdmap.c b/net/ceph/osdmap.c
>> index 2823bb3cff55..cd65677baff3 100644
>> --- a/net/ceph/osdmap.c
>> +++ b/net/ceph/osdmap.c
>> @@ -1549,8 +1549,23 @@ static int decode_primary_affinity(void **p, void *end,
>>          return -EINVAL;
>>    }
>>
>> +static __printf(3, 4)
>> +void print_osd_info(struct ceph_fsid *fsid, u64 gid, const char *fmt, ...)
>> +{
>> +       struct va_format vaf;
>> +       va_list args;
>> +
>> +       va_start(args, fmt);
>> +       vaf.fmt = fmt;
>> +       vaf.va = &args;
>> +
>> +       printk(KERN_INFO "%s (%pU %lld): %pV", KBUILD_MODNAME, fsid, gid, &vaf);
>> +
>> +       va_end(args);
>> +}
>> +
>>    static int decode_new_primary_affinity(void **p, void *end,
>> -                                      struct ceph_osdmap *map)
>> +                                      struct ceph_osdmap *map, u64 gid)
>>    {
>>          u32 n;
>>
>> @@ -1566,7 +1581,8 @@ static int decode_new_primary_affinity(void **p, void *end,
>>                  if (ret)
>>                          return ret;
>>
>> -               pr_info("osd%d primary-affinity 0x%x\n", osd, aff);
>> +               print_osd_info(&map->fsid, gid, "osd%d primary-affinity 0x%x\n",
>> +                              osd, aff);
>>          }
>>
>>          return 0;
>> @@ -1825,7 +1841,8 @@ struct ceph_osdmap *ceph_osdmap_decode(void **p, void *end, bool msgr2)
>>     *     new_state: { osd=6, xorstate=EXISTS } # clear osd_state
>>     */
>>    static int decode_new_up_state_weight(void **p, void *end, u8 struct_v,
>> -                                     bool msgr2, struct ceph_osdmap *map)
>> +                                     bool msgr2, struct ceph_osdmap *map,
>> +                                     u64 gid)
>>    {
>>          void *new_up_client;
>>          void *new_state;
>> @@ -1864,9 +1881,10 @@ static int decode_new_up_state_weight(void **p, void *end, u8 struct_v,
>>                  osd = ceph_decode_32(p);
>>                  w = ceph_decode_32(p);
>>                  BUG_ON(osd >= map->max_osd);
>> -               pr_info("osd%d weight 0x%x %s\n", osd, w,
>> -                    w == CEPH_OSD_IN ? "(in)" :
>> -                    (w == CEPH_OSD_OUT ? "(out)" : ""));
>> +               print_osd_info(&map->fsid, gid, "osd%d weight 0x%x %s\n",
>> +                              osd, w,
>> +                              w == CEPH_OSD_IN ? "(in)" :
>> +                              (w == CEPH_OSD_OUT ? "(out)" : ""));
>>                  map->osd_weight[osd] = w;
>>
>>                  /*
>> @@ -1898,10 +1916,11 @@ static int decode_new_up_state_weight(void **p, void *end, u8 struct_v,
>>                  BUG_ON(osd >= map->max_osd);
>>                  if ((map->osd_state[osd] & CEPH_OSD_UP) &&
>>                      (xorstate & CEPH_OSD_UP))
>> -                       pr_info("osd%d down\n", osd);
>> +                       print_osd_info(&map->fsid, gid, "osd%d down\n", osd);
>>                  if ((map->osd_state[osd] & CEPH_OSD_EXISTS) &&
>>                      (xorstate & CEPH_OSD_EXISTS)) {
>> -                       pr_info("osd%d does not exist\n", osd);
>> +                       print_osd_info(&map->fsid, gid, "osd%d does not exist\n",
>> +                                      osd);
>>                          ret = set_primary_affinity(map, osd,
>>                                                     CEPH_OSD_DEFAULT_PRIMARY_AFFINITY);
>>                          if (ret)
>> @@ -1931,7 +1950,7 @@ static int decode_new_up_state_weight(void **p, void *end, u8 struct_v,
>>
>>                  dout("%s osd%d addr %s\n", __func__, osd, ceph_pr_addr(&addr));
>>
>> -               pr_info("osd%d up\n", osd);
>> +               print_osd_info(&map->fsid, gid, "osd%d up\n", osd);
>>                  map->osd_state[osd] |= CEPH_OSD_EXISTS | CEPH_OSD_UP;
>>                  map->osd_addr[osd] = addr;
>>          }
>> @@ -1947,7 +1966,7 @@ static int decode_new_up_state_weight(void **p, void *end, u8 struct_v,
>>     * decode and apply an incremental map update.
>>     */
>>    struct ceph_osdmap *osdmap_apply_incremental(void **p, void *end, bool msgr2,
>> -                                            struct ceph_osdmap *map)
>> +                                            struct ceph_osdmap *map, u64 gid)
>>    {
>>          struct ceph_fsid fsid;
>>          u32 epoch = 0;
>> @@ -2033,7 +2052,7 @@ struct ceph_osdmap *osdmap_apply_incremental(void **p, void *end, bool msgr2,
>>          }
>>
>>          /* new_up_client, new_state, new_weight */
>> -       err = decode_new_up_state_weight(p, end, struct_v, msgr2, map);
>> +       err = decode_new_up_state_weight(p, end, struct_v, msgr2, map, gid);
>>          if (err)
>>                  goto bad;
>>
>> @@ -2051,7 +2070,7 @@ struct ceph_osdmap *osdmap_apply_incremental(void **p, void *end, bool msgr2,
>>
>>          /* new_primary_affinity */
>>          if (struct_v >= 2) {
>> -               err = decode_new_primary_affinity(p, end, map);
>> +               err = decode_new_primary_affinity(p, end, map, gid);
>>                  if (err)
>>                          goto bad;
>>          }
>> --
>> 2.25.1
> 
> Hi Daichi,
> 
> I played with this a bit and decided that printing gid is not needed
> after all, given that only osdmap messages are changed.  Instead,
> I switched to printing epoch which can be very useful when debugging
> stuck OSD requests.  Here is the patch I ended up with:
> 
>      https://github.com/ceph/ceph-client/commit/b5f9965fad5a4f3a8d17aa234167e8a85e1b9105
> 
> Could you please take a look and let me know if you are OK with it?

Hi Ilya,

I have looked the patch and tried it. It looks good to me.
Thank you very much!

Best,
Daichi
