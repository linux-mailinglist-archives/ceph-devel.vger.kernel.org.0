Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5983A4D6C34
	for <lists+ceph-devel@lfdr.de>; Sat, 12 Mar 2022 04:15:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbiCLDQ4 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 11 Mar 2022 22:16:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbiCLDQy (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 11 Mar 2022 22:16:54 -0500
Received: from APC01-HK2-obe.outbound.protection.outlook.com (mail-eopbgr1300115.outbound.protection.outlook.com [40.107.130.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 744253B3EA
        for <ceph-devel@vger.kernel.org>; Fri, 11 Mar 2022 19:15:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mGfAQDMRKC3y01rBLgNl/hYQ0VQFNYHZzhN7Z+qAGbDP3XwCGdOfp8g1VZIen+iZ5mCgn6t10x7x233S8+ltrnJ3ReIdsOsvjTeJ6lYgMB7tvN9yIg2k5c4F8be3iWSucNpBmi0dpo8jxL21jMs+tH83fIE9FFBIo+v640kbs5FSSTEE7AynABC/xpu4J33hdAmutvfX5UL5BxKtjvKAoMeJlzWr9XpGFGMiOZRsE1lHmdZwxIPC4eQc+qhk4xZ8ilrHhKohTqpOADTToy13CWshK+Uv+ys0QPqmxpOFJ8lwKMAmuqtYB2Pl22Y4GgVHWIaEoNpIaB48qUtAjdrw6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=is9feMO7qghLTmXRcWASGWA/iA5M6ilIaJXf7oYAYHw=;
 b=Wqb0w+l5AETrKCxEjlhi9DxkYVKh8JGq3Wc1yhZnaSR+EipgMItH7sQon9UC7HOpS9ALnIb8Ybe16NArRNYFvk2CtgXfafnkSw7lpU77C6IHzG6LkQpjcyQzYzrwNWZaU9ONUswM2gG882hZnenjU9rq6dPSG94nzZr4Jv5yt1iAGJLzNE/gSSnVqCZSf8DQ913WfugeazA+N7oeybafVo1iCyaiLyTPgSdzQOWwVlaMNO4FZ/jPGGRoAI8Q+SBZZ1YuH063fdDTLEn8jFHeLOOZGygKsedBxYFsn2hzkiT5KMo3ssjJ9SptMrCGu9ZAW7DXBuo43SwBoaa1BaI4bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cybozu.co.jp; dmarc=pass action=none header.from=cybozu.co.jp;
 dkim=pass header.d=cybozu.co.jp; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cybozu.co.jp;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=is9feMO7qghLTmXRcWASGWA/iA5M6ilIaJXf7oYAYHw=;
 b=7jPPeAoi0Pu4QqBb7oMNaDJWbpzcgAOi6uuEdkIB7wpj6yF6h5jPdW2eT35KjGD5e35osL/CHCovehXZuQdSgiTwntxAsrFlcg9dwERBmW6K30BVBe0AdfazWLBdS/+RRr1JVN4wDvzd9Nfh7uvfC2yozmP9sSmhLnFxpsiLcNA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=cybozu.co.jp;
Received: from TY2PR03MB4254.apcprd03.prod.outlook.com (2603:1096:404:b1::17)
 by HK0PR03MB3345.apcprd03.prod.outlook.com (2603:1096:203:57::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.7; Sat, 12 Mar
 2022 03:15:43 +0000
Received: from TY2PR03MB4254.apcprd03.prod.outlook.com
 ([fe80::3d2e:a17b:81d0:f38]) by TY2PR03MB4254.apcprd03.prod.outlook.com
 ([fe80::3d2e:a17b:81d0:f38%6]) with mapi id 15.20.5061.017; Sat, 12 Mar 2022
 03:15:43 +0000
Message-ID: <050545f4-ff14-9d18-d323-850e06f61745@cybozu.co.jp>
Date:   Sat, 12 Mar 2022 12:15:39 +0900
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.2
Subject: Re: [PATCH v2] libceph: print fsid and client gid with mon id and osd
 id
Content-Language: en-US
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>,
        Satoru Takeuchi <satoru.takeuchi@gmail.com>
References: <d0a7e3d1-f9ca-994e-fa6e-b730b443346d@cybozu.co.jp>
 <CAOi1vP9SXGRzQF=Thy70QO0NyGjpPBtmCWyF4pfODJNPrWoX0A@mail.gmail.com>
 <f6f40fc0-5154-57ac-c28a-3d58ed15bd77@cybozu.co.jp>
 <CAOi1vP9zXPek_LKkrT-OvZ0Xa0B=pz90y33TM_CVmsvcH8HPGw@mail.gmail.com>
From:   Daichi Mukai <daichi-mukai@cybozu.co.jp>
In-Reply-To: <CAOi1vP9zXPek_LKkrT-OvZ0Xa0B=pz90y33TM_CVmsvcH8HPGw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TYCPR01CA0044.jpnprd01.prod.outlook.com
 (2603:1096:405:1::32) To TY2PR03MB4254.apcprd03.prod.outlook.com
 (2603:1096:404:b1::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 181ee4ba-2aa5-4753-0e7e-08da03d697b3
X-MS-TrafficTypeDiagnostic: HK0PR03MB3345:EE_
X-Microsoft-Antispam-PRVS: <HK0PR03MB3345D17E1715B7E1E5DE9C6BAC0D9@HK0PR03MB3345.apcprd03.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8Ej/CsewyTJff12CW2QcNWjVQTHO7fcWSuYbcpUFqfhI0nUbIgYMrjSdK5IX+OFP+ukzzkLDOPpThLsASm91iVA2t7KwzZSrebhMuWcO3NZihPuS7UE9LC4cX3maSTE1xBFxLubFR9deluGTdG1adzt4325ekh6r+D69FJufApYc5yW7yCb3p3mtEha3jijHTEke0y+ibh0nYL+XFOf6GXfmUJLF+vkOdWP/YM7MsXB/MNupYPJxz8eglLoscp7SacoWXRry/TfZjHfMNzMLsIoL8hxw2nwI5oRY5yC2c2+DnP0Il2UoopYhigwv3a+G7CfGMRuRomFMnhcQgl1NPPzoNlsypUYhtUMeafQHu/a9N69eTJUm3Z+bc58GjeJJsNENZYNMBqfpPLOto4nH3l40FCgJQvSez40neEXt2HUNzhzqIqU0rVppGcXr6IGvIf7M3T8e20wvjl8CXPV7PR5eV+QwWzadrBUtJ/bEdCsIpzxOaVADxtq2K323jTPvByLp7BKHapoO5YoMpZ22nBHPznuarWIY+2GlAhvzkJaDI8adGAiDHM75IG4bnu5jr64Ic0NeMFTc/yFxtC6XzqQu+EeopvdlGmXOedmTXHNYqrv8cucZqZheOlmit6gOtkBsNh1Vps+1FB2LtEOFJ14YITyk7tuHZ1+mUPvL1jSB61Jvq4C3AbB2dIO9JoR0N2i9bd4A+UbTO5IK2K75UPhoeqTc19Z6RyqRmfkeciXrRm/0hG30NrqlZaSKpOJ0wg+3NL35zSQplkDOtE0XC/dCoCg9pO8As/cHxOIYc0eX7n/kH4lXPTYhW64rxapktTQE66eDjlpeSvoTRKrieCAhSHx7BI82d0JFjrbW5zE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY2PR03MB4254.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(54906003)(6486002)(2616005)(6666004)(5660300002)(36756003)(83380400001)(38350700002)(38100700002)(30864003)(31686004)(966005)(26005)(6916009)(52116002)(66946007)(8936002)(31696002)(316002)(508600001)(6506007)(86362001)(66476007)(186003)(2906002)(4326008)(66556008)(6512007)(53546011)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YUVudGVDMXVzME5MRFhPajVNY3B0cGlTeWxwSFRjbUtOR0RFVHp2VHBUMFMz?=
 =?utf-8?B?VzZmYUVuOUZ3M1J6bTZVc2U4ZS9idTZqcFQ3SWVoVjFZcmZRLzdNNFNXZVd5?=
 =?utf-8?B?RVpxNWxCZ3dBdDFJajk1S1pvRDNvTGdpMmtRdzRtang1blJQYVRkUFU0elpT?=
 =?utf-8?B?YVFZVkZsMkhoNWhnQWhtRGJXczJrcEVhK2tSL3dnOUo2N2tlRkIxTHNiVnVi?=
 =?utf-8?B?MGFaZEtIeUdMQXgwYTdEaE1nYXluYWhNY0pEa0VtWVQveGdGbi9qZFhWYi9r?=
 =?utf-8?B?KzBJelFnL2JyTFdUeHQzOHpkbDV5UnNGUE1GWnpSQW5NOXE0V1JvMmViZ0xR?=
 =?utf-8?B?SU1rSWswTnFDQWowQ1lVM2ltb3pGTEo1RUZpcmdmLzNDSGJNWXoySHAvcnIr?=
 =?utf-8?B?NVVpUWJqTS8yL0tGVkV5Z0RSUHVZcUE0cHE1VTgrQjVJSXI5Z1RPeG5HUk05?=
 =?utf-8?B?YU1xK1BlVXBiQ1dlZFJ1WjZBT1FYVVVQVEp2d0s4MUpXdzArRVlJMmdUamtU?=
 =?utf-8?B?dFlMREgxcG11STUzMDBWZUhHWXplYTh6dW9GUjMxZE5WWU5SNTAyQ01LRGdv?=
 =?utf-8?B?ZkExbFV4cFJ2MGwwSTBIT1NkOWhIRkVERVVIbGdHT2JkcmZQU1o5Wk9CMkwz?=
 =?utf-8?B?TEE5eHl6MGF6THZEODJWa084T1liamNQeWV3amVGdkpEYkVEbFlHM2xranZn?=
 =?utf-8?B?MC9WeHlWdWwwaVFJcHowUnVJbEVxbzNJMXgyMEV5emxOcnVQT1IvbEIrZzk5?=
 =?utf-8?B?Mytia3Rtb1QvRCs5MXB1M1hPR09uYTFEKzVBYVN4MVIwN2ZXKzN0YUVkdkN3?=
 =?utf-8?B?MDc3UnkzNnpMQ1NrWWlZVGVtSEx4T202SjhKUU1GS1F1elltZElGSFJUcGY1?=
 =?utf-8?B?OHhUSHphMFZ0WTB0VjhvZGREWi8yZUtWcmxrcVdmUGYvenFhNzg1SGtHdEdw?=
 =?utf-8?B?QXBMSUFsQytORi9qMmh6SkJRUGFPc0xnc2FWS3BSZVhoWmo3bTVyR1dld2JG?=
 =?utf-8?B?NU1oTlN1UTVyZkF1dWRrdmYzR0lINys2VERmZ1dzVWpFS0VDb2V4aktEeDZh?=
 =?utf-8?B?ODlRSTV4M1pmWVFSTG1VSHZOTmdnVEcvSWNWR2cyU01JN1Y2OWdjRVZyeFdw?=
 =?utf-8?B?bkpEV0RqUXpPRHJwM2JMVmlJWE5qeWgzRTFZODh5aWxwRGJFWlZkUU9FNU1i?=
 =?utf-8?B?VTBzbDZ1cVkxM21HMDlkb0JyclpGdStjajA4NURJMkJvNG1ZeXJoQ2dsM0xy?=
 =?utf-8?B?dUI0SUhKZ2EydmdpUTk5aUx0Q1JXL253TTFmeVFrVjRycCtTRmN0Y2Z6bzhw?=
 =?utf-8?B?SEJtMU5NbTB4azZnRk5EVE5ydmVONnVLWkpnTzB2WUt3VmsxaXJhWEdIdmN3?=
 =?utf-8?B?UmVDYzk2eWIzUXNkamJvZllQWENSU2V2UnNhMFhBc1FSb1RIMkJ4M25PR1NI?=
 =?utf-8?B?RmpNaW1UNklHQ0ZzcUFhazNjN0R0UnFZZkI3eTBhN1pTOGNuUjBNSVo0T091?=
 =?utf-8?B?MC9YeXVEWXIvMnFWdjV1b2xpYWZteE5wMDBoMnpkOGpuOEQrREFsb01uQlJW?=
 =?utf-8?B?ejMxeFZvR3ZYUGdEbkRmWWFXTGtqekJPZE5zc2ZYUzd5c054bDJjeTVEckRi?=
 =?utf-8?B?NEtFYVBmRDdiSllXN05kcElKbGtrM3cyS3lnempNbDNPc2pPMjVUWWdVVWdm?=
 =?utf-8?B?Y1lUL3hoUng5cVRZeGtFd0g5VGtsY0Y2YmFzMjJtS2RwTFcxcXE4ai9xZnc4?=
 =?utf-8?B?SFhNSERNYUtnS0xEbHVKcEtRMWpJT1ZwZm1GSi8zeGxSQWlkS0dYUkZsNFJX?=
 =?utf-8?B?UVpHbGNDN05GV1lQOEUrODZIZ0R5VWIyL2haeVUxWUtTdy9QSFpBOUYrWnlV?=
 =?utf-8?B?VlM4bk9TMFZ3Qks5N2RLdkJES3ZabjFqUWpkV2dwbnlZSmdXTWlYWUNWazIz?=
 =?utf-8?B?K050RnRFc1Z3S0NOQnpleDZDa1ZwWGp2aE9kREk0VG1iNUxRTmxqa05xLzBp?=
 =?utf-8?Q?Tn5FZifWNUY0qIlrwauEAsLzefdhgQ=3D?=
X-OriginatorOrg: cybozu.co.jp
X-MS-Exchange-CrossTenant-Network-Message-Id: 181ee4ba-2aa5-4753-0e7e-08da03d697b3
X-MS-Exchange-CrossTenant-AuthSource: TY2PR03MB4254.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2022 03:15:43.0887
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3761f390-05f7-4386-9a0b-b6806c13b841
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3uuoaP5jtxqRakJ5IqmFXLtFiTVcR8233Jm7vsGltyksx3rxekqIFegqRNTf2Hlf4Ug/eClFxs6HZQZtX1l+arjcMpO8R1hDEhuC+vpRvUnIG2sG6Cd2XndfVOlEYU0N
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HK0PR03MB3345
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2022/03/12 5:52, Ilya Dryomov wrote:
> On Fri, Mar 11, 2022 at 12:05 PM Daichi Mukai <daichi-mukai@cybozu.co.jp> wrote:
>>
>> On 2022/03/11 1:09, Ilya Dryomov wrote:
>>> On Wed, Mar 9, 2022 at 4:12 AM Daichi Mukai <daichi-mukai@cybozu.co.jp> wrote:
>>>>
>>>> Print fsid and client gid in libceph log messages to distinct from which
>>>> each message come.
>>>>
>>>> Signed-off-by: Satoru Takeuchi <satoru.takeuchi@gmail.com>
>>>> Signed-off-by: Daichi Mukai <daichi-mukai@cybozu.co.jp>
>>>>
>>>> ---
>>>> I took over Satoru's patch.
>>>> https://www.spinics.net/lists/ceph-devel/msg51932.html
>>>> ---
>>>>     net/ceph/mon_client.c |  32 +++++---
>>>>     net/ceph/osd_client.c | 166 +++++++++++++++++++++++++++---------------
>>>>     net/ceph/osdmap.c     |  23 +++---
>>>>     3 files changed, 143 insertions(+), 78 deletions(-)
>>>>
>>>> diff --git a/net/ceph/mon_client.c b/net/ceph/mon_client.c
>>>> index 6a6898ee4049..975a8d725e30 100644
>>>> --- a/net/ceph/mon_client.c
>>>> +++ b/net/ceph/mon_client.c
>>>> @@ -141,8 +141,8 @@ static struct ceph_monmap *ceph_monmap_decode(void **p, void *end, bool msgr2)
>>>>                   if (ret)
>>>>                           goto fail;
>>>>
>>>> -               dout("%s mon%d addr %s\n", __func__, i,
>>>> -                    ceph_pr_addr(&inst->addr));
>>>> +               dout("%s mon%d addr %s (fsid %pU)\n", __func__, i,
>>>> +                    ceph_pr_addr(&inst->addr), &monmap->fsid);
>>>>           }
>>>>
>>>>           return monmap;
>>>> @@ -187,7 +187,8 @@ static void __send_prepared_auth_request(struct ceph_mon_client *monc, int len)
>>>>      */
>>>>     static void __close_session(struct ceph_mon_client *monc)
>>>>     {
>>>> -       dout("__close_session closing mon%d\n", monc->cur_mon);
>>>> +       dout("__close_session closing mon%d (fsid %pU client%lld)\n",
>>>> +            monc->cur_mon, &monc->client->fsid, ceph_client_gid(monc->client));
>>>>           ceph_msg_revoke(monc->m_auth);
>>>>           ceph_msg_revoke_incoming(monc->m_auth_reply);
>>>>           ceph_msg_revoke(monc->m_subscribe);
>>>> @@ -229,8 +230,9 @@ static void pick_new_mon(struct ceph_mon_client *monc)
>>>>                   monc->cur_mon = n;
>>>>           }
>>>>
>>>> -       dout("%s mon%d -> mon%d out of %d mons\n", __func__, old_mon,
>>>> -            monc->cur_mon, monc->monmap->num_mon);
>>>> +       dout("%s mon%d -> mon%d out of %d mons (fsid %pU client%lld)\n", __func__,
>>>> +            old_mon, monc->cur_mon, monc->monmap->num_mon,
>>>> +            &monc->client->fsid, ceph_client_gid(monc->client));
>>>>     }
>>>>
>>>>     /*
>>>> @@ -252,7 +254,8 @@ static void __open_session(struct ceph_mon_client *monc)
>>>>           monc->sub_renew_after = jiffies; /* i.e., expired */
>>>>           monc->sub_renew_sent = 0;
>>>>
>>>> -       dout("%s opening mon%d\n", __func__, monc->cur_mon);
>>>> +       dout("%s opening mon%d (fsid %pU client%lld)\n", __func__,
>>>> +            monc->cur_mon, &monc->client->fsid, ceph_client_gid(monc->client));
>>>>           ceph_con_open(&monc->con, CEPH_ENTITY_TYPE_MON, monc->cur_mon,
>>>>                         &monc->monmap->mon_inst[monc->cur_mon].addr);
>>>>
>>>> @@ -279,8 +282,9 @@ static void __open_session(struct ceph_mon_client *monc)
>>>>     static void reopen_session(struct ceph_mon_client *monc)
>>>>     {
>>>>           if (!monc->hunting)
>>>> -               pr_info("mon%d %s session lost, hunting for new mon\n",
>>>> -                   monc->cur_mon, ceph_pr_addr(&monc->con.peer_addr));
>>>> +               pr_info("mon%d %s session lost, hunting for new mon (fsid %pU client%lld)\n",
>>>> +                       monc->cur_mon, ceph_pr_addr(&monc->con.peer_addr),
>>>> +                       &monc->client->fsid, ceph_client_gid(monc->client));
>>>>
>>>>           __close_session(monc);
>>>>           __open_session(monc);
>>>> @@ -1263,7 +1267,9 @@ EXPORT_SYMBOL(ceph_monc_stop);
>>>>     static void finish_hunting(struct ceph_mon_client *monc)
>>>>     {
>>>>           if (monc->hunting) {
>>>> -               dout("%s found mon%d\n", __func__, monc->cur_mon);
>>>> +               dout("%s found mon%d (fsid %pU client%lld)\n", __func__,
>>>> +                    monc->cur_mon, &monc->client->fsid,
>>>> +                    ceph_client_gid(monc->client));
>>>>                   monc->hunting = false;
>>>>                   monc->had_a_connection = true;
>>>>                   un_backoff(monc);
>>>> @@ -1295,8 +1301,9 @@ static void finish_auth(struct ceph_mon_client *monc, int auth_err,
>>>>                   __send_subscribe(monc);
>>>>                   __resend_generic_request(monc);
>>>>
>>>> -               pr_info("mon%d %s session established\n", monc->cur_mon,
>>>> -                       ceph_pr_addr(&monc->con.peer_addr));
>>>> +               pr_info("mon%d %s session established (client%lld)\n",
>>>> +                       monc->cur_mon, ceph_pr_addr(&monc->con.peer_addr),
>>>> +                       ceph_client_gid(monc->client));
>>>>           }
>>>>     }
>>>>
>>>> @@ -1546,7 +1553,8 @@ static void mon_fault(struct ceph_connection *con)
>>>>           struct ceph_mon_client *monc = con->private;
>>>>
>>>>           mutex_lock(&monc->mutex);
>>>> -       dout("%s mon%d\n", __func__, monc->cur_mon);
>>>> +       dout("%s mon%d (fsid %pU client%lld)\n", __func__,
>>>> +            monc->cur_mon, &monc->client->fsid, ceph_client_gid(monc->client));
>>>>           if (monc->cur_mon >= 0) {
>>>>                   if (!monc->hunting) {
>>>>                           dout("%s hunting for new mon\n", __func__);
>>>> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
>>>> index 1c5815530e0d..04d859c04972 100644
>>>> --- a/net/ceph/osd_client.c
>>>> +++ b/net/ceph/osd_client.c
>>>> @@ -1271,7 +1271,8 @@ static void __move_osd_to_lru(struct ceph_osd *osd)
>>>>     {
>>>>           struct ceph_osd_client *osdc = osd->o_osdc;
>>>>
>>>> -       dout("%s osd %p osd%d\n", __func__, osd, osd->o_osd);
>>>> +       dout("%s osd %p osd%d (fsid %pU client%lld)\n", __func__, osd,
>>>> +            osd->o_osd, &osdc->client->fsid, ceph_client_gid(osdc->client));
>>>>           BUG_ON(!list_empty(&osd->o_osd_lru));
>>>>
>>>>           spin_lock(&osdc->osd_lru_lock);
>>>> @@ -1292,7 +1293,8 @@ static void __remove_osd_from_lru(struct ceph_osd *osd)
>>>>     {
>>>>           struct ceph_osd_client *osdc = osd->o_osdc;
>>>>
>>>> -       dout("%s osd %p osd%d\n", __func__, osd, osd->o_osd);
>>>> +       dout("%s osd %p osd%d (fsid %pU client%lld)\n", __func__, osd,
>>>> +            osd->o_osd, &osdc->client->fsid, ceph_client_gid(osdc->client));
>>>>
>>>>           spin_lock(&osdc->osd_lru_lock);
>>>>           if (!list_empty(&osd->o_osd_lru))
>>>> @@ -1310,7 +1312,8 @@ static void close_osd(struct ceph_osd *osd)
>>>>           struct rb_node *n;
>>>>
>>>>           verify_osdc_wrlocked(osdc);
>>>> -       dout("%s osd %p osd%d\n", __func__, osd, osd->o_osd);
>>>> +       dout("%s osd %p osd%d (fsid %pU client%lld)\n", __func__, osd,
>>>> +            osd->o_osd, &osdc->client->fsid, ceph_client_gid(osdc->client));
>>>>
>>>>           ceph_con_close(&osd->o_con);
>>>>
>>>> @@ -1347,9 +1350,11 @@ static void close_osd(struct ceph_osd *osd)
>>>>      */
>>>>     static int reopen_osd(struct ceph_osd *osd)
>>>>     {
>>>> +       struct ceph_osd_client *osdc = osd->o_osdc;
>>>>           struct ceph_entity_addr *peer_addr;
>>>>
>>>> -       dout("%s osd %p osd%d\n", __func__, osd, osd->o_osd);
>>>> +       dout("%s osd %p osd%d (fsid %pU client%lld)\n", __func__, osd,
>>>> +            osd->o_osd, &osdc->client->fsid, ceph_client_gid(osdc->client));
>>>>
>>>>           if (RB_EMPTY_ROOT(&osd->o_requests) &&
>>>>               RB_EMPTY_ROOT(&osd->o_linger_requests)) {
>>>> @@ -1357,7 +1362,7 @@ static int reopen_osd(struct ceph_osd *osd)
>>>>                   return -ENODEV;
>>>>           }
>>>>
>>>> -       peer_addr = &osd->o_osdc->osdmap->osd_addr[osd->o_osd];
>>>> +       peer_addr = &osdc->osdmap->osd_addr[osd->o_osd];
>>>>           if (!memcmp(peer_addr, &osd->o_con.peer_addr, sizeof (*peer_addr)) &&
>>>>                           !ceph_con_opened(&osd->o_con)) {
>>>>                   struct rb_node *n;
>>>> @@ -1405,7 +1410,8 @@ static struct ceph_osd *lookup_create_osd(struct ceph_osd_client *osdc, int o,
>>>>                                 &osdc->osdmap->osd_addr[osd->o_osd]);
>>>>           }
>>>>
>>>> -       dout("%s osdc %p osd%d -> osd %p\n", __func__, osdc, o, osd);
>>>> +       dout("%s osdc %p osd%d -> osd %p (fsid %pU client%lld)\n", __func__,
>>>> +            osdc, o, osd, &osdc->client->fsid, ceph_client_gid(osdc->client));
>>>>           return osd;
>>>>     }
>>>>
>>>> @@ -1416,15 +1422,18 @@ static struct ceph_osd *lookup_create_osd(struct ceph_osd_client *osdc, int o,
>>>>      */
>>>>     static void link_request(struct ceph_osd *osd, struct ceph_osd_request *req)
>>>>     {
>>>> +       struct ceph_osd_client *osdc = osd->o_osdc;
>>>> +
>>>>           verify_osd_locked(osd);
>>>>           WARN_ON(!req->r_tid || req->r_osd);
>>>> -       dout("%s osd %p osd%d req %p tid %llu\n", __func__, osd, osd->o_osd,
>>>> -            req, req->r_tid);
>>>> +       dout("%s osd %p osd%d req %p tid %llu (fsid %pU client%lld)\n",
>>>> +            __func__, osd, osd->o_osd, req, req->r_tid, &osdc->client->fsid,
>>>> +            ceph_client_gid(osdc->client));
>>>>
>>>>           if (!osd_homeless(osd))
>>>>                   __remove_osd_from_lru(osd);
>>>>           else
>>>> -               atomic_inc(&osd->o_osdc->num_homeless);
>>>> +               atomic_inc(&osdc->num_homeless);
>>>>
>>>>           get_osd(osd);
>>>>           insert_request(&osd->o_requests, req);
>>>> @@ -1433,10 +1442,13 @@ static void link_request(struct ceph_osd *osd, struct ceph_osd_request *req)
>>>>
>>>>     static void unlink_request(struct ceph_osd *osd, struct ceph_osd_request *req)
>>>>     {
>>>> +       struct ceph_osd_client *osdc = osd->o_osdc;
>>>> +
>>>>           verify_osd_locked(osd);
>>>>           WARN_ON(req->r_osd != osd);
>>>> -       dout("%s osd %p osd%d req %p tid %llu\n", __func__, osd, osd->o_osd,
>>>> -            req, req->r_tid);
>>>> +       dout("%s osd %p osd%d req %p tid %llu (fsid %pU client%lld)\n",
>>>> +            __func__, osd, osd->o_osd, req, req->r_tid, &osdc->client->fsid,
>>>> +            ceph_client_gid(osdc->client));
>>>>
>>>>           req->r_osd = NULL;
>>>>           erase_request(&osd->o_requests, req);
>>>> @@ -1445,7 +1457,7 @@ static void unlink_request(struct ceph_osd *osd, struct ceph_osd_request *req)
>>>>           if (!osd_homeless(osd))
>>>>                   maybe_move_osd_to_lru(osd);
>>>>           else
>>>> -               atomic_dec(&osd->o_osdc->num_homeless);
>>>> +               atomic_dec(&osdc->num_homeless);
>>>>     }
>>>>
>>>>     static bool __pool_full(struct ceph_pg_pool_info *pi)
>>>> @@ -1532,8 +1544,9 @@ static int pick_closest_replica(struct ceph_osd_client *osdc,
>>>>                   }
>>>>           } while (++i < acting->size);
>>>>
>>>> -       dout("%s picked osd%d with locality %d, primary osd%d\n", __func__,
>>>> -            acting->osds[best_i], best_locality, acting->primary);
>>>> +       dout("%s picked osd%d with locality %d, primary osd%d (fsid %pU client%lld)\n",
>>>> +            __func__, acting->osds[best_i], best_locality, acting->primary,
>>>> +            &osdc->client->fsid, ceph_client_gid(osdc->client));
>>>>           return best_i;
>>>>     }
>>>>
>>>> @@ -1666,8 +1679,10 @@ static enum calc_target_result calc_target(struct ceph_osd_client *osdc,
>>>>                   ct_res = CALC_TARGET_NO_ACTION;
>>>>
>>>>     out:
>>>> -       dout("%s t %p -> %d%d%d%d ct_res %d osd%d\n", __func__, t, unpaused,
>>>> -            legacy_change, force_resend, split, ct_res, t->osd);
>>>> +       dout("%s t %p -> %d%d%d%d ct_res %d osd%d (fsid %pU client%lld)\n",
>>>> +            __func__, t, unpaused, legacy_change, force_resend, split,
>>>> +            ct_res, t->osd, &osdc->client->fsid,
>>>> +            ceph_client_gid(osdc->client));
>>>>           return ct_res;
>>>>     }
>>>>
>>>> @@ -1987,9 +2002,10 @@ static bool should_plug_request(struct ceph_osd_request *req)
>>>>           if (!backoff)
>>>>                   return false;
>>>>
>>>> -       dout("%s req %p tid %llu backoff osd%d spgid %llu.%xs%d id %llu\n",
>>>> -            __func__, req, req->r_tid, osd->o_osd, backoff->spgid.pgid.pool,
>>>> -            backoff->spgid.pgid.seed, backoff->spgid.shard, backoff->id);
>>>> +       dout("%s req %p tid %llu backoff osd%d spgid %llu.%xs%d id %llu (fsid %pU client%lld)\n",
>>>> +            __func__,  req, req->r_tid, osd->o_osd, backoff->spgid.pgid.pool,
>>>> +            backoff->spgid.pgid.seed, backoff->spgid.shard, backoff->id,
>>>> +            &osd->o_osdc->client->fsid, ceph_client_gid(osd->o_osdc->client));
>>>>           return true;
>>>>     }
>>>>
>>>> @@ -2296,11 +2312,12 @@ static void send_request(struct ceph_osd_request *req)
>>>>
>>>>           encode_request_partial(req, req->r_request);
>>>>
>>>> -       dout("%s req %p tid %llu to pgid %llu.%x spgid %llu.%xs%d osd%d e%u flags 0x%x attempt %d\n",
>>>> +       dout("%s req %p tid %llu to pgid %llu.%x spgid %llu.%xs%d osd%d e%u flags 0x%x attempt %d (fsid %pU client%lld)\n",
>>>>                __func__, req, req->r_tid, req->r_t.pgid.pool, req->r_t.pgid.seed,
>>>>                req->r_t.spgid.pgid.pool, req->r_t.spgid.pgid.seed,
>>>> -            req->r_t.spgid.shard, osd->o_osd, req->r_t.epoch, req->r_flags,
>>>> -            req->r_attempts);
>>>> +            req->r_t.spgid.shard, osd->o_osd,
>>>> +            req->r_t.epoch, req->r_flags, req->r_attempts,
>>>> +            &osd->o_osdc->client->fsid, ceph_client_gid(osd->o_osdc->client));
>>>>
>>>>           req->r_t.paused = false;
>>>>           req->r_stamp = jiffies;
>>>> @@ -2788,8 +2805,9 @@ static void link_linger(struct ceph_osd *osd,
>>>>     {
>>>>           verify_osd_locked(osd);
>>>>           WARN_ON(!lreq->linger_id || lreq->osd);
>>>> -       dout("%s osd %p osd%d lreq %p linger_id %llu\n", __func__, osd,
>>>> -            osd->o_osd, lreq, lreq->linger_id);
>>>> +       dout("%s osd %p osd%d lreq %p linger_id %llu (fsid %pU client%lld)\n",
>>>> +            __func__, osd, osd->o_osd, lreq, lreq->linger_id,
>>>> +            &osd->o_osdc->client->fsid, ceph_client_gid(osd->o_osdc->client));
>>>>
>>>>           if (!osd_homeless(osd))
>>>>                   __remove_osd_from_lru(osd);
>>>> @@ -2806,8 +2824,9 @@ static void unlink_linger(struct ceph_osd *osd,
>>>>     {
>>>>           verify_osd_locked(osd);
>>>>           WARN_ON(lreq->osd != osd);
>>>> -       dout("%s osd %p osd%d lreq %p linger_id %llu\n", __func__, osd,
>>>> -            osd->o_osd, lreq, lreq->linger_id);
>>>> +       dout("%s osd %p osd%d lreq %p linger_id %llu  (fsid %pU client%lld)\n",
>>>> +            __func__, osd, osd->o_osd, lreq, lreq->linger_id,
>>>> +            &osd->o_osdc->client->fsid, ceph_client_gid(osd->o_osdc->client));
>>>>
>>>>           lreq->osd = NULL;
>>>>           erase_linger(&osd->o_linger_requests, lreq);
>>>> @@ -3357,14 +3376,18 @@ static void handle_timeout(struct work_struct *work)
>>>>                           p = rb_next(p); /* abort_request() */
>>>>
>>>>                           if (time_before(req->r_stamp, cutoff)) {
>>>> -                               dout(" req %p tid %llu on osd%d is laggy\n",
>>>> -                                    req, req->r_tid, osd->o_osd);
>>>> +                               dout(" req %p tid %llu on osd%d is laggy (fsid %pU client%lld)\n",
>>>> +                                    req, req->r_tid, osd->o_osd,
>>>> +                                    &osdc->client->fsid,
>>>> +                                    ceph_client_gid(osdc->client));
>>>>                                   found = true;
>>>>                           }
>>>>                           if (opts->osd_request_timeout &&
>>>>                               time_before(req->r_start_stamp, expiry_cutoff)) {
>>>> -                               pr_err_ratelimited("tid %llu on osd%d timeout\n",
>>>> -                                      req->r_tid, osd->o_osd);
>>>> +                               pr_err_ratelimited("tid %llu on osd%d timeout (fsid %pU client%lld)\n",
>>>> +                                      req->r_tid, osd->o_osd,
>>>> +                                      &osdc->client->fsid,
>>>> +                                      ceph_client_gid(osdc->client));
>>>>                                   abort_request(req, -ETIMEDOUT);
>>>>                           }
>>>>                   }
>>>> @@ -3372,8 +3395,10 @@ static void handle_timeout(struct work_struct *work)
>>>>                           struct ceph_osd_linger_request *lreq =
>>>>                               rb_entry(p, struct ceph_osd_linger_request, node);
>>>>
>>>> -                       dout(" lreq %p linger_id %llu is served by osd%d\n",
>>>> -                            lreq, lreq->linger_id, osd->o_osd);
>>>> +                       dout(" lreq %p linger_id %llu is served by osd%d (fsid %pU client%lld)\n",
>>>> +                            lreq, lreq->linger_id, osd->o_osd,
>>>> +                            &osdc->client->fsid,
>>>> +                            ceph_client_gid(osdc->client));
>>>>                           found = true;
>>>>
>>>>                           mutex_lock(&lreq->lock);
>>>> @@ -3394,8 +3419,10 @@ static void handle_timeout(struct work_struct *work)
>>>>                           p = rb_next(p); /* abort_request() */
>>>>
>>>>                           if (time_before(req->r_start_stamp, expiry_cutoff)) {
>>>> -                               pr_err_ratelimited("tid %llu on osd%d timeout\n",
>>>> -                                      req->r_tid, osdc->homeless_osd.o_osd);
>>>> +                               pr_err_ratelimited("tid %llu on osd%d timeout (fsid %pU client%lld)\n",
>>>> +                                      req->r_tid, osdc->homeless_osd.o_osd,
>>>> +                                      &osdc->client->fsid,
>>>> +                                      ceph_client_gid(osdc->client));
>>>>                                   abort_request(req, -ETIMEDOUT);
>>>>                           }
>>>>                   }
>>>> @@ -3662,7 +3689,9 @@ static void handle_reply(struct ceph_osd *osd, struct ceph_msg *msg)
>>>>
>>>>           down_read(&osdc->lock);
>>>>           if (!osd_registered(osd)) {
>>>> -               dout("%s osd%d unknown\n", __func__, osd->o_osd);
>>>> +               dout("%s osd%d unknown (fsid %pU client%lld)\n", __func__,
>>>> +                    osd->o_osd, &osd->o_osdc->client->fsid,
>>>> +                    ceph_client_gid(osdc->client));
>>>>                   goto out_unlock_osdc;
>>>>           }
>>>>           WARN_ON(osd->o_osd != le64_to_cpu(msg->hdr.src.num));
>>>> @@ -3670,7 +3699,9 @@ static void handle_reply(struct ceph_osd *osd, struct ceph_msg *msg)
>>>>           mutex_lock(&osd->lock);
>>>>           req = lookup_request(&osd->o_requests, tid);
>>>>           if (!req) {
>>>> -               dout("%s osd%d tid %llu unknown\n", __func__, osd->o_osd, tid);
>>>> +               dout("%s osd%d tid %llu unknown (fsid %pU client%lld)\n",
>>>> +                    __func__, osd->o_osd, tid, &osd->o_osdc->client->fsid,
>>>> +                    ceph_client_gid(osdc->client));
>>>>                   goto out_unlock_session;
>>>>           }
>>>>
>>>> @@ -4180,11 +4211,14 @@ static void osd_fault(struct ceph_connection *con)
>>>>           struct ceph_osd *osd = con->private;
>>>>           struct ceph_osd_client *osdc = osd->o_osdc;
>>>>
>>>> -       dout("%s osd %p osd%d\n", __func__, osd, osd->o_osd);
>>>> +       dout("%s osd %p osd%d (fsid %pU client%lld)\n", __func__, osd,
>>>> +            osd->o_osd, &osdc->client->fsid, ceph_client_gid(osdc->client));
>>>>
>>>>           down_write(&osdc->lock);
>>>>           if (!osd_registered(osd)) {
>>>> -               dout("%s osd%d unknown\n", __func__, osd->o_osd);
>>>> +               dout("%s osd%d unknown (fsid %pU client%lld)\n", __func__,
>>>> +                    osd->o_osd, &osdc->client->fsid,
>>>> +                    ceph_client_gid(osdc->client));
>>>>                   goto out_unlock;
>>>>           }
>>>>
>>>> @@ -4299,8 +4333,10 @@ static void handle_backoff_block(struct ceph_osd *osd, struct MOSDBackoff *m)
>>>>           struct ceph_osd_backoff *backoff;
>>>>           struct ceph_msg *msg;
>>>>
>>>> -       dout("%s osd%d spgid %llu.%xs%d id %llu\n", __func__, osd->o_osd,
>>>> -            m->spgid.pgid.pool, m->spgid.pgid.seed, m->spgid.shard, m->id);
>>>> +       dout("%s osd%d spgid %llu.%xs%d id %llu (fsid %pU client%lld)\n",
>>>> +            __func__, osd->o_osd, m->spgid.pgid.pool, m->spgid.pgid.seed,
>>>> +            m->spgid.shard, m->id, &osd->o_osdc->client->fsid,
>>>> +            ceph_client_gid(osd->o_osdc->client));
>>>>
>>>>           spg = lookup_spg_mapping(&osd->o_backoff_mappings, &m->spgid);
>>>>           if (!spg) {
>>>> @@ -4359,22 +4395,28 @@ static void handle_backoff_unblock(struct ceph_osd *osd,
>>>>           struct ceph_osd_backoff *backoff;
>>>>           struct rb_node *n;
>>>>
>>>> -       dout("%s osd%d spgid %llu.%xs%d id %llu\n", __func__, osd->o_osd,
>>>> -            m->spgid.pgid.pool, m->spgid.pgid.seed, m->spgid.shard, m->id);
>>>> +       dout("%s osd%d spgid %llu.%xs%d id %llu (fsid %pU client%lld)\n",
>>>> +            __func__, osd->o_osd, m->spgid.pgid.pool, m->spgid.pgid.seed,
>>>> +            m->spgid.shard, m->id, &osd->o_osdc->client->fsid,
>>>> +            ceph_client_gid(osd->o_osdc->client));
>>>>
>>>>           backoff = lookup_backoff_by_id(&osd->o_backoffs_by_id, m->id);
>>>>           if (!backoff) {
>>>> -               pr_err("%s osd%d spgid %llu.%xs%d id %llu backoff dne\n",
>>>> +               pr_err("%s osd%d spgid %llu.%xs%d id %llu backoff dne (fsid %pU client%lld)\n",
>>>>                          __func__, osd->o_osd, m->spgid.pgid.pool,
>>>> -                      m->spgid.pgid.seed, m->spgid.shard, m->id);
>>>> +                      m->spgid.pgid.seed, m->spgid.shard, m->id,
>>>> +                      &osd->o_osdc->client->fsid,
>>>> +                      ceph_client_gid(osd->o_osdc->client));
>>>>                   return;
>>>>           }
>>>>
>>>>           if (hoid_compare(backoff->begin, m->begin) &&
>>>>               hoid_compare(backoff->end, m->end)) {
>>>> -               pr_err("%s osd%d spgid %llu.%xs%d id %llu bad range?\n",
>>>> +               pr_err("%s osd%d spgid %llu.%xs%d id %llu bad range? (fsid %pU client%lld)\n",
>>>>                          __func__, osd->o_osd, m->spgid.pgid.pool,
>>>> -                      m->spgid.pgid.seed, m->spgid.shard, m->id);
>>>> +                      m->spgid.pgid.seed, m->spgid.shard, m->id,
>>>> +                      &osd->o_osdc->client->fsid,
>>>> +                      ceph_client_gid(osd->o_osdc->client));
>>>>                   /* unblock it anyway... */
>>>>           }
>>>>
>>>> @@ -4418,7 +4460,9 @@ static void handle_backoff(struct ceph_osd *osd, struct ceph_msg *msg)
>>>>
>>>>           down_read(&osdc->lock);
>>>>           if (!osd_registered(osd)) {
>>>> -               dout("%s osd%d unknown\n", __func__, osd->o_osd);
>>>> +               dout("%s osd%d unknown (fsid %pU client%lld)\n", __func__,
>>>> +                    osd->o_osd, &osd->o_osdc->client->fsid,
>>>> +                    ceph_client_gid(osdc->client));
>>>>                   up_read(&osdc->lock);
>>>>                   return;
>>>>           }
>>>> @@ -4440,7 +4484,9 @@ static void handle_backoff(struct ceph_osd *osd, struct ceph_msg *msg)
>>>>                   handle_backoff_unblock(osd, &m);
>>>>                   break;
>>>>           default:
>>>> -               pr_err("%s osd%d unknown op %d\n", __func__, osd->o_osd, m.op);
>>>> +               pr_err("%s osd%d unknown op %d (fsid %pU client%lld)\n",
>>>> +                      __func__, osd->o_osd, m.op, &osd->o_osdc->client->fsid,
>>>> +                      ceph_client_gid(osdc->client));
>>>>           }
>>>>
>>>>           free_hoid(m.begin);
>>>> @@ -5417,7 +5463,9 @@ static struct ceph_msg *get_reply(struct ceph_connection *con,
>>>>
>>>>           down_read(&osdc->lock);
>>>>           if (!osd_registered(osd)) {
>>>> -               dout("%s osd%d unknown, skipping\n", __func__, osd->o_osd);
>>>> +               dout("%s osd%d unknown, skipping (fsid %pU client%lld)\n",
>>>> +                    __func__, osd->o_osd, &osdc->client->fsid,
>>>> +                    ceph_client_gid(osdc->client));
>>>>                   *skip = 1;
>>>>                   goto out_unlock_osdc;
>>>>           }
>>>> @@ -5426,8 +5474,9 @@ static struct ceph_msg *get_reply(struct ceph_connection *con,
>>>>           mutex_lock(&osd->lock);
>>>>           req = lookup_request(&osd->o_requests, tid);
>>>>           if (!req) {
>>>> -               dout("%s osd%d tid %llu unknown, skipping\n", __func__,
>>>> -                    osd->o_osd, tid);
>>>> +               dout("%s osd%d tid %llu unknown, skipping (fsid %pU client%lld)\n",
>>>> +                    __func__, osd->o_osd, tid, &osdc->client->fsid,
>>>> +                    ceph_client_gid(osdc->client));
>>>>                   *skip = 1;
>>>>                   goto out_unlock_session;
>>>>           }
>>>> @@ -5435,9 +5484,10 @@ static struct ceph_msg *get_reply(struct ceph_connection *con,
>>>>           ceph_msg_revoke_incoming(req->r_reply);
>>>>
>>>>           if (front_len > req->r_reply->front_alloc_len) {
>>>> -               pr_warn("%s osd%d tid %llu front %d > preallocated %d\n",
>>>> +               pr_warn("%s osd%d tid %llu front %d > preallocated %d (fsid %pU client%lld)\n",
>>>>                           __func__, osd->o_osd, req->r_tid, front_len,
>>>> -                       req->r_reply->front_alloc_len);
>>>> +                       req->r_reply->front_alloc_len, &osdc->client->fsid,
>>>> +                       ceph_client_gid(osdc->client));
>>>>                   m = ceph_msg_new(CEPH_MSG_OSD_OPREPLY, front_len, GFP_NOFS,
>>>>                                    false);
>>>>                   if (!m)
>>>> @@ -5447,9 +5497,10 @@ static struct ceph_msg *get_reply(struct ceph_connection *con,
>>>>           }
>>>>
>>>>           if (data_len > req->r_reply->data_length) {
>>>> -               pr_warn("%s osd%d tid %llu data %d > preallocated %zu, skipping\n",
>>>> +               pr_warn("%s osd%d tid %llu data %d > preallocated %zu, skipping (fsid %pU client%lld)\n",
>>>>                           __func__, osd->o_osd, req->r_tid, data_len,
>>>> -                       req->r_reply->data_length);
>>>> +                       req->r_reply->data_length, &osdc->client->fsid,
>>>> +                       ceph_client_gid(osdc->client));
>>>>                   m = NULL;
>>>>                   *skip = 1;
>>>>                   goto out_unlock_session;
>>>> @@ -5508,8 +5559,9 @@ static struct ceph_msg *osd_alloc_msg(struct ceph_connection *con,
>>>>           case CEPH_MSG_OSD_OPREPLY:
>>>>                   return get_reply(con, hdr, skip);
>>>>           default:
>>>> -               pr_warn("%s osd%d unknown msg type %d, skipping\n", __func__,
>>>> -                       osd->o_osd, type);
>>>> +               pr_warn("%s osd%d unknown msg type %d, skipping (fsid %pU client%lld)\n",
>>>> +                       __func__, osd->o_osd, type, &osd->o_osdc->client->fsid,
>>>> +                       ceph_client_gid(osd->o_osdc->client));
>>>>                   *skip = 1;
>>>>                   return NULL;
>>>>           }
>>>> diff --git a/net/ceph/osdmap.c b/net/ceph/osdmap.c
>>>> index 2823bb3cff55..a9cbd8b88929 100644
>>>> --- a/net/ceph/osdmap.c
>>>> +++ b/net/ceph/osdmap.c
>>>> @@ -1566,7 +1566,8 @@ static int decode_new_primary_affinity(void **p, void *end,
>>>>                   if (ret)
>>>>                           return ret;
>>>>
>>>> -               pr_info("osd%d primary-affinity 0x%x\n", osd, aff);
>>>> +               pr_info("osd%d primary-affinity 0x%x (fsid %pU)\n", osd, aff,
>>>> +                       &map->fsid);
>>>>           }
>>>>
>>>>           return 0;
>>>> @@ -1728,7 +1729,8 @@ static int osdmap_decode(void **p, void *end, bool msgr2,
>>>>                   if (err)
>>>>                           goto bad;
>>>>
>>>> -               dout("%s osd%d addr %s\n", __func__, i, ceph_pr_addr(addr));
>>>> +               dout("%s osd%d addr %s (fsid %pU)\n", __func__, i,
>>>> +                    ceph_pr_addr(addr), &map->fsid);
>>>>           }
>>>>
>>>>           /* pg_temp */
>>>> @@ -1864,9 +1866,10 @@ static int decode_new_up_state_weight(void **p, void *end, u8 struct_v,
>>>>                   osd = ceph_decode_32(p);
>>>>                   w = ceph_decode_32(p);
>>>>                   BUG_ON(osd >= map->max_osd);
>>>> -               pr_info("osd%d weight 0x%x %s\n", osd, w,
>>>> -                    w == CEPH_OSD_IN ? "(in)" :
>>>> -                    (w == CEPH_OSD_OUT ? "(out)" : ""));
>>>> +               pr_info("osd%d weight 0x%x %s (fsid %pU)\n", osd, w,
>>>> +                       w == CEPH_OSD_IN ? "(in)" :
>>>> +                       (w == CEPH_OSD_OUT ? "(out)" : ""),
>>>> +                       &map->fsid);
>>>>                   map->osd_weight[osd] = w;
>>>>
>>>>                   /*
>>>> @@ -1898,10 +1901,11 @@ static int decode_new_up_state_weight(void **p, void *end, u8 struct_v,
>>>>                   BUG_ON(osd >= map->max_osd);
>>>>                   if ((map->osd_state[osd] & CEPH_OSD_UP) &&
>>>>                       (xorstate & CEPH_OSD_UP))
>>>> -                       pr_info("osd%d down\n", osd);
>>>> +                       pr_info("osd%d down (fsid %pU)\n", osd, &map->fsid);
>>>>                   if ((map->osd_state[osd] & CEPH_OSD_EXISTS) &&
>>>>                       (xorstate & CEPH_OSD_EXISTS)) {
>>>> -                       pr_info("osd%d does not exist\n", osd);
>>>> +                       pr_info("osd%d does not exist (fsid %pU)\n", osd,
>>>> +                               &map->fsid);
>>>>                           ret = set_primary_affinity(map, osd,
>>>>                                                      CEPH_OSD_DEFAULT_PRIMARY_AFFINITY);
>>>>                           if (ret)
>>>> @@ -1929,9 +1933,10 @@ static int decode_new_up_state_weight(void **p, void *end, u8 struct_v,
>>>>                   if (ret)
>>>>                           return ret;
>>>>
>>>> -               dout("%s osd%d addr %s\n", __func__, osd, ceph_pr_addr(&addr));
>>>> +               dout("%s osd%d addr %s (fsid %pU)\n", __func__, osd,
>>>> +                    ceph_pr_addr(&addr), &map->fsid);
>>>>
>>>> -               pr_info("osd%d up\n", osd);
>>>> +               pr_info("osd%d up (fsid %pU)\n", osd, &map->fsid);
>>>>                   map->osd_state[osd] |= CEPH_OSD_EXISTS | CEPH_OSD_UP;
>>>>                   map->osd_addr[osd] = addr;
>>>>           }
>>>> --
>>>> 2.25.1
>>>
>>> Hi Daichi,
>>>
>>> I would suggest two things:
>>>
>>> 1) Leave dout messages alone for now.  They aren't shown by default and
>>>      are there for developers to do debugging.  In that setting, multiple
>>>      clusters or client instances should be rare.
>>
>> Sure, I'll leave dout messages alone.
>>
>>> 2) For pr_info/pr_warn/etc messages, make the format consistent and
>>>      more grepable, e.g.
>>>
>>>        libceph (<fsid> <gid>): <message>
>>>
>>>        libceph (ef1ab157-688c-483b-a94d-0aeec9ca44e0 4181): osd10 down
>>>
>>>      as I suggested earlier.  Sometimes printing just the fsid, sometimes
>>>      the fsid and the gid and sometimes none is undesirable.
>>
>> Let me confirm two points:
>>
>> - For consistency, should all pr_info/pr_warn/etc messages in libceph
>>     uses format with fsid and gid? Or does your suggestion means messages
>>     with osd or mon id (i.e. messages which I had edited in this patch)
>>     should have consistent format?
> 
> Definitely not all messages.  I'd start with those that are most common
> and that _you_ think are important to distinguish between.  Whether mon
> or osd id is included is probably irrelevant.
> 
> The reason I'm deferring to you here is that I haven't seen this come
> up as an issue.  99% of users would connect to a single Ceph cluster
> (which means a single fsid) with a single libceph instance (which means
> a single gid).
> 
> But consistency is very important, so IMO a particular message should
> either be not touched at all or be converted to a consistent format.
> 
>>
>> - What should be displayed if fsid or gid cannot be obtained? For example,
>>     we may not know fsid yet when establishing session with mon. Also,
>>     decode_new_up_state_weight() outputs message like "osd10 down" etc, but
>>     it seems not easy to get client gid within this function. This is why
>>     there are sometimes fsid only and sometimes gid only and sometimes both
>>     in my patch.
> 
> For when the mon session is being established, do nothing (i.e.
> leave existing messages as is).  For after the fsid and gid become
> known, either convert to a consistent format with both fsid and gid or
> do nothing if the message isn't important.  If this causes too much
> code churn because of additional parameters being passed around, we may
> need to reconsider whether this change is worth it at all.

Thank you for your kind comments. They are very helpful for me. I'll think
again about when fsid and gid in the logs are useful.

Daichi
