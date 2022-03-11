Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F2494D605E
	for <lists+ceph-devel@lfdr.de>; Fri, 11 Mar 2022 12:05:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347636AbiCKLG0 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 11 Mar 2022 06:06:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231795AbiCKLGZ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 11 Mar 2022 06:06:25 -0500
Received: from APC01-HK2-obe.outbound.protection.outlook.com (mail-eopbgr1300111.outbound.protection.outlook.com [40.107.130.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D592186B9B
        for <ceph-devel@vger.kernel.org>; Fri, 11 Mar 2022 03:05:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k8mMZeWFTF/Z5XI4FjnuxSyWuEsni0mGsYlI/G98Rgq4agWw/A/cH5rTJPgAb2QANy9r03GRrby5+Z2BgYZlHWjUHzSiqATQUT/KvnS3TbVvY/m4QsC0XmaYgCzr9hhf9a5rg4zA88OFUKsI67T62vSkWCrtl9idFFMmhj9Ox0UlU30wcHDTBZ5BijQjp+f7W296keVHfuJ54Tr7O7COfNKuRoS9vd/CdO3iSmKMPOcEu6HjhKik2pbotcGacmYQJ+/wg4YCN9G3ieTMesRMgcyMrvK22dwbmuqLkvZ8Vjn0hyG24nFl6amVAkam0Krr3EhwzrAVq1yGVo/1F7J+tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6ZaO+dUEh9QMO7WtpnMr9YOSPxXzJnCxsLYdpKgDxgE=;
 b=Di3/d+SNPqznnV7vEW2m7TvSczl5uxzjCxKhVHkuUMeh4/mra6RhLxlqNjOAONqDWi2tJ3i5zILI1cEfNPvt37NKJcGGlkxoFvd/+7NpY5/yyGqoUc/kKx5WKVRAFTigD5DKeSgtdTcf6/S9CyJaJmR8uPGovIWGMofYf6dy643hcQvImspF+1GXWBkCzbRH9ZKH7nNKqT2z9rGlwGSwxI/FRQSxX9IDxJvPQPmMC2SvZ98KTgzTgpm0J4tNNJuy3zwdapbiin3/JhQYLAOalF/DDBa4OE4QhblEn07OOeCiIo06Qujd19CKBZLtEBZNOeLahWFkHQIIILDSMDSb+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cybozu.co.jp; dmarc=pass action=none header.from=cybozu.co.jp;
 dkim=pass header.d=cybozu.co.jp; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cybozu.co.jp;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6ZaO+dUEh9QMO7WtpnMr9YOSPxXzJnCxsLYdpKgDxgE=;
 b=mnmKbBIitxuQCimcRooEsvf+hejvhVGDMCCFFKimPPHT9Vl0YUbSW5OKC4iC17chmLfJW9ui5NJpqsGhlijAZbQrvD/DPeTWq/xqn97SEw0olJ2keStCBYpkm8stQ1wxHXNH9urKau8OoX//aT1pUS+dPMFV6JiXsxkHMSvobjY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=cybozu.co.jp;
Received: from TY2PR03MB4254.apcprd03.prod.outlook.com (2603:1096:404:b1::17)
 by SEZPR03MB6763.apcprd03.prod.outlook.com (2603:1096:101:66::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.8; Fri, 11 Mar
 2022 11:05:17 +0000
Received: from TY2PR03MB4254.apcprd03.prod.outlook.com
 ([fe80::3d2e:a17b:81d0:f38]) by TY2PR03MB4254.apcprd03.prod.outlook.com
 ([fe80::3d2e:a17b:81d0:f38%6]) with mapi id 15.20.5061.017; Fri, 11 Mar 2022
 11:05:17 +0000
Message-ID: <f6f40fc0-5154-57ac-c28a-3d58ed15bd77@cybozu.co.jp>
Date:   Fri, 11 Mar 2022 20:05:15 +0900
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.2
From:   Daichi Mukai <daichi-mukai@cybozu.co.jp>
Subject: Re: [PATCH v2] libceph: print fsid and client gid with mon id and osd
 id
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>,
        Satoru Takeuchi <satoru.takeuchi@gmail.com>
References: <d0a7e3d1-f9ca-994e-fa6e-b730b443346d@cybozu.co.jp>
 <CAOi1vP9SXGRzQF=Thy70QO0NyGjpPBtmCWyF4pfODJNPrWoX0A@mail.gmail.com>
Content-Language: en-US
In-Reply-To: <CAOi1vP9SXGRzQF=Thy70QO0NyGjpPBtmCWyF4pfODJNPrWoX0A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TY2PR06CA0007.apcprd06.prod.outlook.com
 (2603:1096:404:42::19) To TY2PR03MB4254.apcprd03.prod.outlook.com
 (2603:1096:404:b1::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d4dee141-f115-42b9-51cf-08da034f0641
X-MS-TrafficTypeDiagnostic: SEZPR03MB6763:EE_
X-Microsoft-Antispam-PRVS: <SEZPR03MB676351EBC71AEA3A8B175039AC0C9@SEZPR03MB6763.apcprd03.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HvUCBnhfpQ+nD6eFy4tbctsc1etOXLzSC/vJSQU2+Jzl1jMm1iG7N1XX+lep26o5dQgXBQTIU5rxUKltLADmaNGCsrlaR4gZdEYVilfzhVuMzDXgUcmrCi+gJBaN5S9pq+0tndvt3+XEq8wuDpOyk73LtXByVMTBHRe6bJAnpWk0AxwmKsbJN/6VOUbSAKm7zbxjGVCy9IAkZ4Xj5dvj6PqysNt4Urxm6cm3W3+43QExo3JJxO8LT3z3/NmbuvWlkHyQaESCaHCA9SFbs96ykywDePC37MmwE37mN6uzIOwtz/eyQzEzWBtcR6PbK+gtD8qmT1uecdzT6LrWrJDvlJtciuglXH2tibw9gIgjJiS5GPXNrNmCvyAy4gSEp0zXy9h4IGOQ/ns/hyyQ6VkVuXYqhcyCR94/Y03lmveLVRUZmkQ5R1wgtXa8htMKAqWwJzCj9CbtvyjlEAaTEn5KhyKMmrGJm7uJrhdiE+/pqdinww6Oydfkvr3ICzRyWtjxrjDlVJn5Vhw4Cp2v8VU85cHoE9SmMhiOwvINjVo5rht71LQ2iN724pYHE2NzXgjjgIJMDQv6s0r71U+t2csLRSR51e068KN8/u5KfVCO0twEeqarwgYM13PdqEsnJQeKx9fazHYpYd6Hw8xY9Iaj2Jqht6B14i7Nz9jW/+hU1bvImaFQQqU6NEhlEhmwXoeJ4NpyFiCzJwZLGrKJC+nmnBLFeHxUSbOnvlFFh2j1QTRG+/MZ5npcjHcWRb2Ta79PyT5V4geonYfJAtPQWTlTR+b8jpo+esFaeZgVlPZ3HH6NnuKHpiV+pZ1q6ESUm4IlHeTAOPk05DOsnpCGAHepbPLwjZ0xEZJq/1lCT5d2OAZUSCSlIu3mg6/TVQVPk82FYePficqJHQa4bzi7HOOVgA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY2PR03MB4254.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2616005)(66556008)(38350700002)(66476007)(38100700002)(83380400001)(186003)(6916009)(26005)(316002)(36756003)(54906003)(5660300002)(31686004)(66946007)(52116002)(6506007)(30864003)(86362001)(966005)(8936002)(6486002)(53546011)(2906002)(508600001)(8676002)(4326008)(31696002)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?REpRVjJDMTRaWGN0VHZudzI0UjNYeG5ndHVrYnhEemVPTGZ0N1BFK1ZUR1Yz?=
 =?utf-8?B?RC96VzRTL1hXdy84ZEhQQmg2MGdtcFJZTGpTamFPRS9Jd1JCU2xMUE1qTkZh?=
 =?utf-8?B?OFRUMEV2Tytmd2FSNzJpYXIzdDhaaEVPQWIxdzFRTE8rNnh1eVdOcmZ0Ynl2?=
 =?utf-8?B?ZlE2ZC9Jallydm5IR05RSnZ5UnBlWUQxcE5kK05JYTNHa1ZMdnpSTys0Z29F?=
 =?utf-8?B?cjJ4V0RzZ3hqZzA1UkxTeGQvMkErOFkzN0dJbEFoK2FacXBOQUZpeEppeEt0?=
 =?utf-8?B?WTh2L0hPRDNxZjI1OGxJQWNiWTRrcDd6Q1hwTXhtTWhVbHJaR3dlamkrQXJW?=
 =?utf-8?B?ZGxvRTl3SWNJbkY1Zm9QQTRxNXhqdEJNeW05WElTS20ySjN2SS9KaC9QK09p?=
 =?utf-8?B?N1ZxMDVwcXBJSUtFdXNUa1MreSt4UGhrMlVodTlRNGMxMStyT3VKOHVxSXFC?=
 =?utf-8?B?N2dYSFpRRVRCUDN4bWZwUCtoNkxhTThibDAyMlhQcGVyaE1ySjZFeFo0bXZY?=
 =?utf-8?B?VmVlcld5QWp0cFRjSThIc0FEdGpIZjQydXFtZ3VOMnZXeDh4TVh0NkxkUVdj?=
 =?utf-8?B?YXBxN0h3ZEZzbXVzaGxQbU5vVVV1bXBPUW9nQ2ZYRHJFU0NjV0h4NWM1akdJ?=
 =?utf-8?B?a1hoeEFGbFJPQkdpenpaa09tZmNYUmRGYVZ1QUNkOFFFUlBOekZKU0hBa1Nz?=
 =?utf-8?B?MEl2ci94YWdLNXZBcXAvUUMzU0dQand6akk3RGR0UW42VEpGdXQyenM3eFlx?=
 =?utf-8?B?NzBkTEZRclpSajdtV3B2eGFoT0Zsbi83aWlkL01vR010b0VOVC9nRHY2cVJ5?=
 =?utf-8?B?a3pEY3JWWHYzdHliT2hMRUgweGgxL1ZxOXdLY2dYM0dlUC9QdUFMZThlSmcz?=
 =?utf-8?B?Y0VMTGJHYlFaeXRIUXpqeUcxMldoM0pBeWh0UkhJL2JRNERNUmhwM2tQWE96?=
 =?utf-8?B?SERJTVFnRWpDWi9tdm0zREZWdS9GcG9UY2pZL2lUWTk4dExzNEtpRUtPbjhO?=
 =?utf-8?B?TFhsekRKeFE1OXdBdk43UFczemZIU3dENmpkclluT3lnUFFaTlY3TGVDZytt?=
 =?utf-8?B?RjJxNlhBMXpmcDYzK3B0dGtSVWUvK2xrUE9xUFI3SlRLVWNGQkVJQ0F6YkRH?=
 =?utf-8?B?RHNNUExvV1o2SlFNdGx4U05lSzFvUDdmS085MGpEc2lFMlZrdXFxUkFXVkI5?=
 =?utf-8?B?RDlmaWZ4VU5rOG9CY21jSHVQMXlIVStvVmlzaEJhMjAzeTJrVjZlUHM0bkFt?=
 =?utf-8?B?MXQzU21leThZWU5WYnhVVkNta09kbmlmVURJVzBBUnRlTXkyTVlWUHhad2Ji?=
 =?utf-8?B?UnNNRGxjaGpVQ1pLYjRVNy8rYkhROWZoK1JLa05qcjRHeTlvellWL2lMWjFo?=
 =?utf-8?B?VXQrcmRteHFjU3YxWHU2TW5XMU9LVnluWUYyQStYSXY2QmhOdmNXUFY1OUY2?=
 =?utf-8?B?NGs4N2ZGUDB6N1NhUE1xd2xGMzF6dkUrM09KVlA2WW1uWUZ2bEhPSHR0S0Nk?=
 =?utf-8?B?dTRTMmpjQWxkY2ZkMWdZSW9LelVrMS90eVgvc1pldGp0ak9QeHZ3NFJtWGRi?=
 =?utf-8?B?MnNXeHFselRHRDlodEhaSld1MFROa0R1ZWtvSEhsdnNmZ3NaTkd3UjF6RUFo?=
 =?utf-8?B?YmVZTlhMWldnNVRTQlJjUzhrNk9JNGFieWluWXBKejJyTXdickdiTjhLUjZF?=
 =?utf-8?B?UEN6VzBFQzZGcS9XUmdPU0Q1YXV1SWV5RStQR1JVWXlqQmxPbWpFSCt4VXdI?=
 =?utf-8?B?djArVE5wVVVoSCtnMnE1bDVvdGkvQ2hwV2o3QUdNNzh0N1o1a213bDI2SFg0?=
 =?utf-8?B?emlmc1hzMm5hRFlxeEMwZ0VURUFldzdOYWtFS0VVUjNmc2thaEhQMHBGNUo1?=
 =?utf-8?B?aDdqa3FCeWY2REFrM0JNWldqN1VCZEdVMmNURU9NV0RZbkl4Yy9qc2ZvdXpw?=
 =?utf-8?B?S2F3c0drTDNNQzk4SWYwSG9qRDczN3JNbHUvVzlEY3JlaGw1ZW9QYW1iRnFy?=
 =?utf-8?Q?7/5xUomuiyJZwDjifJldwVlM1fCD+s=3D?=
X-OriginatorOrg: cybozu.co.jp
X-MS-Exchange-CrossTenant-Network-Message-Id: d4dee141-f115-42b9-51cf-08da034f0641
X-MS-Exchange-CrossTenant-AuthSource: TY2PR03MB4254.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2022 11:05:17.2340
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3761f390-05f7-4386-9a0b-b6806c13b841
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f50LUf6Wi1F1mJBjm9iJ+SbYS7xh0KrzErLjrjQ4Ek8TvA8/n//9j2UzX4b7s8hP/TQjqWpgMOPonyavZ9T1wmRTLdCiV4GdtNaRyLiXc6euL3huYwAsQxpyeFoBSEZq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR03MB6763
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2022/03/11 1:09, Ilya Dryomov wrote:
> On Wed, Mar 9, 2022 at 4:12 AM Daichi Mukai <daichi-mukai@cybozu.co.jp> wrote:
>>
>> Print fsid and client gid in libceph log messages to distinct from which
>> each message come.
>>
>> Signed-off-by: Satoru Takeuchi <satoru.takeuchi@gmail.com>
>> Signed-off-by: Daichi Mukai <daichi-mukai@cybozu.co.jp>
>>
>> ---
>> I took over Satoru's patch.
>> https://www.spinics.net/lists/ceph-devel/msg51932.html
>> ---
>>    net/ceph/mon_client.c |  32 +++++---
>>    net/ceph/osd_client.c | 166 +++++++++++++++++++++++++++---------------
>>    net/ceph/osdmap.c     |  23 +++---
>>    3 files changed, 143 insertions(+), 78 deletions(-)
>>
>> diff --git a/net/ceph/mon_client.c b/net/ceph/mon_client.c
>> index 6a6898ee4049..975a8d725e30 100644
>> --- a/net/ceph/mon_client.c
>> +++ b/net/ceph/mon_client.c
>> @@ -141,8 +141,8 @@ static struct ceph_monmap *ceph_monmap_decode(void **p, void *end, bool msgr2)
>>                  if (ret)
>>                          goto fail;
>>
>> -               dout("%s mon%d addr %s\n", __func__, i,
>> -                    ceph_pr_addr(&inst->addr));
>> +               dout("%s mon%d addr %s (fsid %pU)\n", __func__, i,
>> +                    ceph_pr_addr(&inst->addr), &monmap->fsid);
>>          }
>>
>>          return monmap;
>> @@ -187,7 +187,8 @@ static void __send_prepared_auth_request(struct ceph_mon_client *monc, int len)
>>     */
>>    static void __close_session(struct ceph_mon_client *monc)
>>    {
>> -       dout("__close_session closing mon%d\n", monc->cur_mon);
>> +       dout("__close_session closing mon%d (fsid %pU client%lld)\n",
>> +            monc->cur_mon, &monc->client->fsid, ceph_client_gid(monc->client));
>>          ceph_msg_revoke(monc->m_auth);
>>          ceph_msg_revoke_incoming(monc->m_auth_reply);
>>          ceph_msg_revoke(monc->m_subscribe);
>> @@ -229,8 +230,9 @@ static void pick_new_mon(struct ceph_mon_client *monc)
>>                  monc->cur_mon = n;
>>          }
>>
>> -       dout("%s mon%d -> mon%d out of %d mons\n", __func__, old_mon,
>> -            monc->cur_mon, monc->monmap->num_mon);
>> +       dout("%s mon%d -> mon%d out of %d mons (fsid %pU client%lld)\n", __func__,
>> +            old_mon, monc->cur_mon, monc->monmap->num_mon,
>> +            &monc->client->fsid, ceph_client_gid(monc->client));
>>    }
>>
>>    /*
>> @@ -252,7 +254,8 @@ static void __open_session(struct ceph_mon_client *monc)
>>          monc->sub_renew_after = jiffies; /* i.e., expired */
>>          monc->sub_renew_sent = 0;
>>
>> -       dout("%s opening mon%d\n", __func__, monc->cur_mon);
>> +       dout("%s opening mon%d (fsid %pU client%lld)\n", __func__,
>> +            monc->cur_mon, &monc->client->fsid, ceph_client_gid(monc->client));
>>          ceph_con_open(&monc->con, CEPH_ENTITY_TYPE_MON, monc->cur_mon,
>>                        &monc->monmap->mon_inst[monc->cur_mon].addr);
>>
>> @@ -279,8 +282,9 @@ static void __open_session(struct ceph_mon_client *monc)
>>    static void reopen_session(struct ceph_mon_client *monc)
>>    {
>>          if (!monc->hunting)
>> -               pr_info("mon%d %s session lost, hunting for new mon\n",
>> -                   monc->cur_mon, ceph_pr_addr(&monc->con.peer_addr));
>> +               pr_info("mon%d %s session lost, hunting for new mon (fsid %pU client%lld)\n",
>> +                       monc->cur_mon, ceph_pr_addr(&monc->con.peer_addr),
>> +                       &monc->client->fsid, ceph_client_gid(monc->client));
>>
>>          __close_session(monc);
>>          __open_session(monc);
>> @@ -1263,7 +1267,9 @@ EXPORT_SYMBOL(ceph_monc_stop);
>>    static void finish_hunting(struct ceph_mon_client *monc)
>>    {
>>          if (monc->hunting) {
>> -               dout("%s found mon%d\n", __func__, monc->cur_mon);
>> +               dout("%s found mon%d (fsid %pU client%lld)\n", __func__,
>> +                    monc->cur_mon, &monc->client->fsid,
>> +                    ceph_client_gid(monc->client));
>>                  monc->hunting = false;
>>                  monc->had_a_connection = true;
>>                  un_backoff(monc);
>> @@ -1295,8 +1301,9 @@ static void finish_auth(struct ceph_mon_client *monc, int auth_err,
>>                  __send_subscribe(monc);
>>                  __resend_generic_request(monc);
>>
>> -               pr_info("mon%d %s session established\n", monc->cur_mon,
>> -                       ceph_pr_addr(&monc->con.peer_addr));
>> +               pr_info("mon%d %s session established (client%lld)\n",
>> +                       monc->cur_mon, ceph_pr_addr(&monc->con.peer_addr),
>> +                       ceph_client_gid(monc->client));
>>          }
>>    }
>>
>> @@ -1546,7 +1553,8 @@ static void mon_fault(struct ceph_connection *con)
>>          struct ceph_mon_client *monc = con->private;
>>
>>          mutex_lock(&monc->mutex);
>> -       dout("%s mon%d\n", __func__, monc->cur_mon);
>> +       dout("%s mon%d (fsid %pU client%lld)\n", __func__,
>> +            monc->cur_mon, &monc->client->fsid, ceph_client_gid(monc->client));
>>          if (monc->cur_mon >= 0) {
>>                  if (!monc->hunting) {
>>                          dout("%s hunting for new mon\n", __func__);
>> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
>> index 1c5815530e0d..04d859c04972 100644
>> --- a/net/ceph/osd_client.c
>> +++ b/net/ceph/osd_client.c
>> @@ -1271,7 +1271,8 @@ static void __move_osd_to_lru(struct ceph_osd *osd)
>>    {
>>          struct ceph_osd_client *osdc = osd->o_osdc;
>>
>> -       dout("%s osd %p osd%d\n", __func__, osd, osd->o_osd);
>> +       dout("%s osd %p osd%d (fsid %pU client%lld)\n", __func__, osd,
>> +            osd->o_osd, &osdc->client->fsid, ceph_client_gid(osdc->client));
>>          BUG_ON(!list_empty(&osd->o_osd_lru));
>>
>>          spin_lock(&osdc->osd_lru_lock);
>> @@ -1292,7 +1293,8 @@ static void __remove_osd_from_lru(struct ceph_osd *osd)
>>    {
>>          struct ceph_osd_client *osdc = osd->o_osdc;
>>
>> -       dout("%s osd %p osd%d\n", __func__, osd, osd->o_osd);
>> +       dout("%s osd %p osd%d (fsid %pU client%lld)\n", __func__, osd,
>> +            osd->o_osd, &osdc->client->fsid, ceph_client_gid(osdc->client));
>>
>>          spin_lock(&osdc->osd_lru_lock);
>>          if (!list_empty(&osd->o_osd_lru))
>> @@ -1310,7 +1312,8 @@ static void close_osd(struct ceph_osd *osd)
>>          struct rb_node *n;
>>
>>          verify_osdc_wrlocked(osdc);
>> -       dout("%s osd %p osd%d\n", __func__, osd, osd->o_osd);
>> +       dout("%s osd %p osd%d (fsid %pU client%lld)\n", __func__, osd,
>> +            osd->o_osd, &osdc->client->fsid, ceph_client_gid(osdc->client));
>>
>>          ceph_con_close(&osd->o_con);
>>
>> @@ -1347,9 +1350,11 @@ static void close_osd(struct ceph_osd *osd)
>>     */
>>    static int reopen_osd(struct ceph_osd *osd)
>>    {
>> +       struct ceph_osd_client *osdc = osd->o_osdc;
>>          struct ceph_entity_addr *peer_addr;
>>
>> -       dout("%s osd %p osd%d\n", __func__, osd, osd->o_osd);
>> +       dout("%s osd %p osd%d (fsid %pU client%lld)\n", __func__, osd,
>> +            osd->o_osd, &osdc->client->fsid, ceph_client_gid(osdc->client));
>>
>>          if (RB_EMPTY_ROOT(&osd->o_requests) &&
>>              RB_EMPTY_ROOT(&osd->o_linger_requests)) {
>> @@ -1357,7 +1362,7 @@ static int reopen_osd(struct ceph_osd *osd)
>>                  return -ENODEV;
>>          }
>>
>> -       peer_addr = &osd->o_osdc->osdmap->osd_addr[osd->o_osd];
>> +       peer_addr = &osdc->osdmap->osd_addr[osd->o_osd];
>>          if (!memcmp(peer_addr, &osd->o_con.peer_addr, sizeof (*peer_addr)) &&
>>                          !ceph_con_opened(&osd->o_con)) {
>>                  struct rb_node *n;
>> @@ -1405,7 +1410,8 @@ static struct ceph_osd *lookup_create_osd(struct ceph_osd_client *osdc, int o,
>>                                &osdc->osdmap->osd_addr[osd->o_osd]);
>>          }
>>
>> -       dout("%s osdc %p osd%d -> osd %p\n", __func__, osdc, o, osd);
>> +       dout("%s osdc %p osd%d -> osd %p (fsid %pU client%lld)\n", __func__,
>> +            osdc, o, osd, &osdc->client->fsid, ceph_client_gid(osdc->client));
>>          return osd;
>>    }
>>
>> @@ -1416,15 +1422,18 @@ static struct ceph_osd *lookup_create_osd(struct ceph_osd_client *osdc, int o,
>>     */
>>    static void link_request(struct ceph_osd *osd, struct ceph_osd_request *req)
>>    {
>> +       struct ceph_osd_client *osdc = osd->o_osdc;
>> +
>>          verify_osd_locked(osd);
>>          WARN_ON(!req->r_tid || req->r_osd);
>> -       dout("%s osd %p osd%d req %p tid %llu\n", __func__, osd, osd->o_osd,
>> -            req, req->r_tid);
>> +       dout("%s osd %p osd%d req %p tid %llu (fsid %pU client%lld)\n",
>> +            __func__, osd, osd->o_osd, req, req->r_tid, &osdc->client->fsid,
>> +            ceph_client_gid(osdc->client));
>>
>>          if (!osd_homeless(osd))
>>                  __remove_osd_from_lru(osd);
>>          else
>> -               atomic_inc(&osd->o_osdc->num_homeless);
>> +               atomic_inc(&osdc->num_homeless);
>>
>>          get_osd(osd);
>>          insert_request(&osd->o_requests, req);
>> @@ -1433,10 +1442,13 @@ static void link_request(struct ceph_osd *osd, struct ceph_osd_request *req)
>>
>>    static void unlink_request(struct ceph_osd *osd, struct ceph_osd_request *req)
>>    {
>> +       struct ceph_osd_client *osdc = osd->o_osdc;
>> +
>>          verify_osd_locked(osd);
>>          WARN_ON(req->r_osd != osd);
>> -       dout("%s osd %p osd%d req %p tid %llu\n", __func__, osd, osd->o_osd,
>> -            req, req->r_tid);
>> +       dout("%s osd %p osd%d req %p tid %llu (fsid %pU client%lld)\n",
>> +            __func__, osd, osd->o_osd, req, req->r_tid, &osdc->client->fsid,
>> +            ceph_client_gid(osdc->client));
>>
>>          req->r_osd = NULL;
>>          erase_request(&osd->o_requests, req);
>> @@ -1445,7 +1457,7 @@ static void unlink_request(struct ceph_osd *osd, struct ceph_osd_request *req)
>>          if (!osd_homeless(osd))
>>                  maybe_move_osd_to_lru(osd);
>>          else
>> -               atomic_dec(&osd->o_osdc->num_homeless);
>> +               atomic_dec(&osdc->num_homeless);
>>    }
>>
>>    static bool __pool_full(struct ceph_pg_pool_info *pi)
>> @@ -1532,8 +1544,9 @@ static int pick_closest_replica(struct ceph_osd_client *osdc,
>>                  }
>>          } while (++i < acting->size);
>>
>> -       dout("%s picked osd%d with locality %d, primary osd%d\n", __func__,
>> -            acting->osds[best_i], best_locality, acting->primary);
>> +       dout("%s picked osd%d with locality %d, primary osd%d (fsid %pU client%lld)\n",
>> +            __func__, acting->osds[best_i], best_locality, acting->primary,
>> +            &osdc->client->fsid, ceph_client_gid(osdc->client));
>>          return best_i;
>>    }
>>
>> @@ -1666,8 +1679,10 @@ static enum calc_target_result calc_target(struct ceph_osd_client *osdc,
>>                  ct_res = CALC_TARGET_NO_ACTION;
>>
>>    out:
>> -       dout("%s t %p -> %d%d%d%d ct_res %d osd%d\n", __func__, t, unpaused,
>> -            legacy_change, force_resend, split, ct_res, t->osd);
>> +       dout("%s t %p -> %d%d%d%d ct_res %d osd%d (fsid %pU client%lld)\n",
>> +            __func__, t, unpaused, legacy_change, force_resend, split,
>> +            ct_res, t->osd, &osdc->client->fsid,
>> +            ceph_client_gid(osdc->client));
>>          return ct_res;
>>    }
>>
>> @@ -1987,9 +2002,10 @@ static bool should_plug_request(struct ceph_osd_request *req)
>>          if (!backoff)
>>                  return false;
>>
>> -       dout("%s req %p tid %llu backoff osd%d spgid %llu.%xs%d id %llu\n",
>> -            __func__, req, req->r_tid, osd->o_osd, backoff->spgid.pgid.pool,
>> -            backoff->spgid.pgid.seed, backoff->spgid.shard, backoff->id);
>> +       dout("%s req %p tid %llu backoff osd%d spgid %llu.%xs%d id %llu (fsid %pU client%lld)\n",
>> +            __func__,  req, req->r_tid, osd->o_osd, backoff->spgid.pgid.pool,
>> +            backoff->spgid.pgid.seed, backoff->spgid.shard, backoff->id,
>> +            &osd->o_osdc->client->fsid, ceph_client_gid(osd->o_osdc->client));
>>          return true;
>>    }
>>
>> @@ -2296,11 +2312,12 @@ static void send_request(struct ceph_osd_request *req)
>>
>>          encode_request_partial(req, req->r_request);
>>
>> -       dout("%s req %p tid %llu to pgid %llu.%x spgid %llu.%xs%d osd%d e%u flags 0x%x attempt %d\n",
>> +       dout("%s req %p tid %llu to pgid %llu.%x spgid %llu.%xs%d osd%d e%u flags 0x%x attempt %d (fsid %pU client%lld)\n",
>>               __func__, req, req->r_tid, req->r_t.pgid.pool, req->r_t.pgid.seed,
>>               req->r_t.spgid.pgid.pool, req->r_t.spgid.pgid.seed,
>> -            req->r_t.spgid.shard, osd->o_osd, req->r_t.epoch, req->r_flags,
>> -            req->r_attempts);
>> +            req->r_t.spgid.shard, osd->o_osd,
>> +            req->r_t.epoch, req->r_flags, req->r_attempts,
>> +            &osd->o_osdc->client->fsid, ceph_client_gid(osd->o_osdc->client));
>>
>>          req->r_t.paused = false;
>>          req->r_stamp = jiffies;
>> @@ -2788,8 +2805,9 @@ static void link_linger(struct ceph_osd *osd,
>>    {
>>          verify_osd_locked(osd);
>>          WARN_ON(!lreq->linger_id || lreq->osd);
>> -       dout("%s osd %p osd%d lreq %p linger_id %llu\n", __func__, osd,
>> -            osd->o_osd, lreq, lreq->linger_id);
>> +       dout("%s osd %p osd%d lreq %p linger_id %llu (fsid %pU client%lld)\n",
>> +            __func__, osd, osd->o_osd, lreq, lreq->linger_id,
>> +            &osd->o_osdc->client->fsid, ceph_client_gid(osd->o_osdc->client));
>>
>>          if (!osd_homeless(osd))
>>                  __remove_osd_from_lru(osd);
>> @@ -2806,8 +2824,9 @@ static void unlink_linger(struct ceph_osd *osd,
>>    {
>>          verify_osd_locked(osd);
>>          WARN_ON(lreq->osd != osd);
>> -       dout("%s osd %p osd%d lreq %p linger_id %llu\n", __func__, osd,
>> -            osd->o_osd, lreq, lreq->linger_id);
>> +       dout("%s osd %p osd%d lreq %p linger_id %llu  (fsid %pU client%lld)\n",
>> +            __func__, osd, osd->o_osd, lreq, lreq->linger_id,
>> +            &osd->o_osdc->client->fsid, ceph_client_gid(osd->o_osdc->client));
>>
>>          lreq->osd = NULL;
>>          erase_linger(&osd->o_linger_requests, lreq);
>> @@ -3357,14 +3376,18 @@ static void handle_timeout(struct work_struct *work)
>>                          p = rb_next(p); /* abort_request() */
>>
>>                          if (time_before(req->r_stamp, cutoff)) {
>> -                               dout(" req %p tid %llu on osd%d is laggy\n",
>> -                                    req, req->r_tid, osd->o_osd);
>> +                               dout(" req %p tid %llu on osd%d is laggy (fsid %pU client%lld)\n",
>> +                                    req, req->r_tid, osd->o_osd,
>> +                                    &osdc->client->fsid,
>> +                                    ceph_client_gid(osdc->client));
>>                                  found = true;
>>                          }
>>                          if (opts->osd_request_timeout &&
>>                              time_before(req->r_start_stamp, expiry_cutoff)) {
>> -                               pr_err_ratelimited("tid %llu on osd%d timeout\n",
>> -                                      req->r_tid, osd->o_osd);
>> +                               pr_err_ratelimited("tid %llu on osd%d timeout (fsid %pU client%lld)\n",
>> +                                      req->r_tid, osd->o_osd,
>> +                                      &osdc->client->fsid,
>> +                                      ceph_client_gid(osdc->client));
>>                                  abort_request(req, -ETIMEDOUT);
>>                          }
>>                  }
>> @@ -3372,8 +3395,10 @@ static void handle_timeout(struct work_struct *work)
>>                          struct ceph_osd_linger_request *lreq =
>>                              rb_entry(p, struct ceph_osd_linger_request, node);
>>
>> -                       dout(" lreq %p linger_id %llu is served by osd%d\n",
>> -                            lreq, lreq->linger_id, osd->o_osd);
>> +                       dout(" lreq %p linger_id %llu is served by osd%d (fsid %pU client%lld)\n",
>> +                            lreq, lreq->linger_id, osd->o_osd,
>> +                            &osdc->client->fsid,
>> +                            ceph_client_gid(osdc->client));
>>                          found = true;
>>
>>                          mutex_lock(&lreq->lock);
>> @@ -3394,8 +3419,10 @@ static void handle_timeout(struct work_struct *work)
>>                          p = rb_next(p); /* abort_request() */
>>
>>                          if (time_before(req->r_start_stamp, expiry_cutoff)) {
>> -                               pr_err_ratelimited("tid %llu on osd%d timeout\n",
>> -                                      req->r_tid, osdc->homeless_osd.o_osd);
>> +                               pr_err_ratelimited("tid %llu on osd%d timeout (fsid %pU client%lld)\n",
>> +                                      req->r_tid, osdc->homeless_osd.o_osd,
>> +                                      &osdc->client->fsid,
>> +                                      ceph_client_gid(osdc->client));
>>                                  abort_request(req, -ETIMEDOUT);
>>                          }
>>                  }
>> @@ -3662,7 +3689,9 @@ static void handle_reply(struct ceph_osd *osd, struct ceph_msg *msg)
>>
>>          down_read(&osdc->lock);
>>          if (!osd_registered(osd)) {
>> -               dout("%s osd%d unknown\n", __func__, osd->o_osd);
>> +               dout("%s osd%d unknown (fsid %pU client%lld)\n", __func__,
>> +                    osd->o_osd, &osd->o_osdc->client->fsid,
>> +                    ceph_client_gid(osdc->client));
>>                  goto out_unlock_osdc;
>>          }
>>          WARN_ON(osd->o_osd != le64_to_cpu(msg->hdr.src.num));
>> @@ -3670,7 +3699,9 @@ static void handle_reply(struct ceph_osd *osd, struct ceph_msg *msg)
>>          mutex_lock(&osd->lock);
>>          req = lookup_request(&osd->o_requests, tid);
>>          if (!req) {
>> -               dout("%s osd%d tid %llu unknown\n", __func__, osd->o_osd, tid);
>> +               dout("%s osd%d tid %llu unknown (fsid %pU client%lld)\n",
>> +                    __func__, osd->o_osd, tid, &osd->o_osdc->client->fsid,
>> +                    ceph_client_gid(osdc->client));
>>                  goto out_unlock_session;
>>          }
>>
>> @@ -4180,11 +4211,14 @@ static void osd_fault(struct ceph_connection *con)
>>          struct ceph_osd *osd = con->private;
>>          struct ceph_osd_client *osdc = osd->o_osdc;
>>
>> -       dout("%s osd %p osd%d\n", __func__, osd, osd->o_osd);
>> +       dout("%s osd %p osd%d (fsid %pU client%lld)\n", __func__, osd,
>> +            osd->o_osd, &osdc->client->fsid, ceph_client_gid(osdc->client));
>>
>>          down_write(&osdc->lock);
>>          if (!osd_registered(osd)) {
>> -               dout("%s osd%d unknown\n", __func__, osd->o_osd);
>> +               dout("%s osd%d unknown (fsid %pU client%lld)\n", __func__,
>> +                    osd->o_osd, &osdc->client->fsid,
>> +                    ceph_client_gid(osdc->client));
>>                  goto out_unlock;
>>          }
>>
>> @@ -4299,8 +4333,10 @@ static void handle_backoff_block(struct ceph_osd *osd, struct MOSDBackoff *m)
>>          struct ceph_osd_backoff *backoff;
>>          struct ceph_msg *msg;
>>
>> -       dout("%s osd%d spgid %llu.%xs%d id %llu\n", __func__, osd->o_osd,
>> -            m->spgid.pgid.pool, m->spgid.pgid.seed, m->spgid.shard, m->id);
>> +       dout("%s osd%d spgid %llu.%xs%d id %llu (fsid %pU client%lld)\n",
>> +            __func__, osd->o_osd, m->spgid.pgid.pool, m->spgid.pgid.seed,
>> +            m->spgid.shard, m->id, &osd->o_osdc->client->fsid,
>> +            ceph_client_gid(osd->o_osdc->client));
>>
>>          spg = lookup_spg_mapping(&osd->o_backoff_mappings, &m->spgid);
>>          if (!spg) {
>> @@ -4359,22 +4395,28 @@ static void handle_backoff_unblock(struct ceph_osd *osd,
>>          struct ceph_osd_backoff *backoff;
>>          struct rb_node *n;
>>
>> -       dout("%s osd%d spgid %llu.%xs%d id %llu\n", __func__, osd->o_osd,
>> -            m->spgid.pgid.pool, m->spgid.pgid.seed, m->spgid.shard, m->id);
>> +       dout("%s osd%d spgid %llu.%xs%d id %llu (fsid %pU client%lld)\n",
>> +            __func__, osd->o_osd, m->spgid.pgid.pool, m->spgid.pgid.seed,
>> +            m->spgid.shard, m->id, &osd->o_osdc->client->fsid,
>> +            ceph_client_gid(osd->o_osdc->client));
>>
>>          backoff = lookup_backoff_by_id(&osd->o_backoffs_by_id, m->id);
>>          if (!backoff) {
>> -               pr_err("%s osd%d spgid %llu.%xs%d id %llu backoff dne\n",
>> +               pr_err("%s osd%d spgid %llu.%xs%d id %llu backoff dne (fsid %pU client%lld)\n",
>>                         __func__, osd->o_osd, m->spgid.pgid.pool,
>> -                      m->spgid.pgid.seed, m->spgid.shard, m->id);
>> +                      m->spgid.pgid.seed, m->spgid.shard, m->id,
>> +                      &osd->o_osdc->client->fsid,
>> +                      ceph_client_gid(osd->o_osdc->client));
>>                  return;
>>          }
>>
>>          if (hoid_compare(backoff->begin, m->begin) &&
>>              hoid_compare(backoff->end, m->end)) {
>> -               pr_err("%s osd%d spgid %llu.%xs%d id %llu bad range?\n",
>> +               pr_err("%s osd%d spgid %llu.%xs%d id %llu bad range? (fsid %pU client%lld)\n",
>>                         __func__, osd->o_osd, m->spgid.pgid.pool,
>> -                      m->spgid.pgid.seed, m->spgid.shard, m->id);
>> +                      m->spgid.pgid.seed, m->spgid.shard, m->id,
>> +                      &osd->o_osdc->client->fsid,
>> +                      ceph_client_gid(osd->o_osdc->client));
>>                  /* unblock it anyway... */
>>          }
>>
>> @@ -4418,7 +4460,9 @@ static void handle_backoff(struct ceph_osd *osd, struct ceph_msg *msg)
>>
>>          down_read(&osdc->lock);
>>          if (!osd_registered(osd)) {
>> -               dout("%s osd%d unknown\n", __func__, osd->o_osd);
>> +               dout("%s osd%d unknown (fsid %pU client%lld)\n", __func__,
>> +                    osd->o_osd, &osd->o_osdc->client->fsid,
>> +                    ceph_client_gid(osdc->client));
>>                  up_read(&osdc->lock);
>>                  return;
>>          }
>> @@ -4440,7 +4484,9 @@ static void handle_backoff(struct ceph_osd *osd, struct ceph_msg *msg)
>>                  handle_backoff_unblock(osd, &m);
>>                  break;
>>          default:
>> -               pr_err("%s osd%d unknown op %d\n", __func__, osd->o_osd, m.op);
>> +               pr_err("%s osd%d unknown op %d (fsid %pU client%lld)\n",
>> +                      __func__, osd->o_osd, m.op, &osd->o_osdc->client->fsid,
>> +                      ceph_client_gid(osdc->client));
>>          }
>>
>>          free_hoid(m.begin);
>> @@ -5417,7 +5463,9 @@ static struct ceph_msg *get_reply(struct ceph_connection *con,
>>
>>          down_read(&osdc->lock);
>>          if (!osd_registered(osd)) {
>> -               dout("%s osd%d unknown, skipping\n", __func__, osd->o_osd);
>> +               dout("%s osd%d unknown, skipping (fsid %pU client%lld)\n",
>> +                    __func__, osd->o_osd, &osdc->client->fsid,
>> +                    ceph_client_gid(osdc->client));
>>                  *skip = 1;
>>                  goto out_unlock_osdc;
>>          }
>> @@ -5426,8 +5474,9 @@ static struct ceph_msg *get_reply(struct ceph_connection *con,
>>          mutex_lock(&osd->lock);
>>          req = lookup_request(&osd->o_requests, tid);
>>          if (!req) {
>> -               dout("%s osd%d tid %llu unknown, skipping\n", __func__,
>> -                    osd->o_osd, tid);
>> +               dout("%s osd%d tid %llu unknown, skipping (fsid %pU client%lld)\n",
>> +                    __func__, osd->o_osd, tid, &osdc->client->fsid,
>> +                    ceph_client_gid(osdc->client));
>>                  *skip = 1;
>>                  goto out_unlock_session;
>>          }
>> @@ -5435,9 +5484,10 @@ static struct ceph_msg *get_reply(struct ceph_connection *con,
>>          ceph_msg_revoke_incoming(req->r_reply);
>>
>>          if (front_len > req->r_reply->front_alloc_len) {
>> -               pr_warn("%s osd%d tid %llu front %d > preallocated %d\n",
>> +               pr_warn("%s osd%d tid %llu front %d > preallocated %d (fsid %pU client%lld)\n",
>>                          __func__, osd->o_osd, req->r_tid, front_len,
>> -                       req->r_reply->front_alloc_len);
>> +                       req->r_reply->front_alloc_len, &osdc->client->fsid,
>> +                       ceph_client_gid(osdc->client));
>>                  m = ceph_msg_new(CEPH_MSG_OSD_OPREPLY, front_len, GFP_NOFS,
>>                                   false);
>>                  if (!m)
>> @@ -5447,9 +5497,10 @@ static struct ceph_msg *get_reply(struct ceph_connection *con,
>>          }
>>
>>          if (data_len > req->r_reply->data_length) {
>> -               pr_warn("%s osd%d tid %llu data %d > preallocated %zu, skipping\n",
>> +               pr_warn("%s osd%d tid %llu data %d > preallocated %zu, skipping (fsid %pU client%lld)\n",
>>                          __func__, osd->o_osd, req->r_tid, data_len,
>> -                       req->r_reply->data_length);
>> +                       req->r_reply->data_length, &osdc->client->fsid,
>> +                       ceph_client_gid(osdc->client));
>>                  m = NULL;
>>                  *skip = 1;
>>                  goto out_unlock_session;
>> @@ -5508,8 +5559,9 @@ static struct ceph_msg *osd_alloc_msg(struct ceph_connection *con,
>>          case CEPH_MSG_OSD_OPREPLY:
>>                  return get_reply(con, hdr, skip);
>>          default:
>> -               pr_warn("%s osd%d unknown msg type %d, skipping\n", __func__,
>> -                       osd->o_osd, type);
>> +               pr_warn("%s osd%d unknown msg type %d, skipping (fsid %pU client%lld)\n",
>> +                       __func__, osd->o_osd, type, &osd->o_osdc->client->fsid,
>> +                       ceph_client_gid(osd->o_osdc->client));
>>                  *skip = 1;
>>                  return NULL;
>>          }
>> diff --git a/net/ceph/osdmap.c b/net/ceph/osdmap.c
>> index 2823bb3cff55..a9cbd8b88929 100644
>> --- a/net/ceph/osdmap.c
>> +++ b/net/ceph/osdmap.c
>> @@ -1566,7 +1566,8 @@ static int decode_new_primary_affinity(void **p, void *end,
>>                  if (ret)
>>                          return ret;
>>
>> -               pr_info("osd%d primary-affinity 0x%x\n", osd, aff);
>> +               pr_info("osd%d primary-affinity 0x%x (fsid %pU)\n", osd, aff,
>> +                       &map->fsid);
>>          }
>>
>>          return 0;
>> @@ -1728,7 +1729,8 @@ static int osdmap_decode(void **p, void *end, bool msgr2,
>>                  if (err)
>>                          goto bad;
>>
>> -               dout("%s osd%d addr %s\n", __func__, i, ceph_pr_addr(addr));
>> +               dout("%s osd%d addr %s (fsid %pU)\n", __func__, i,
>> +                    ceph_pr_addr(addr), &map->fsid);
>>          }
>>
>>          /* pg_temp */
>> @@ -1864,9 +1866,10 @@ static int decode_new_up_state_weight(void **p, void *end, u8 struct_v,
>>                  osd = ceph_decode_32(p);
>>                  w = ceph_decode_32(p);
>>                  BUG_ON(osd >= map->max_osd);
>> -               pr_info("osd%d weight 0x%x %s\n", osd, w,
>> -                    w == CEPH_OSD_IN ? "(in)" :
>> -                    (w == CEPH_OSD_OUT ? "(out)" : ""));
>> +               pr_info("osd%d weight 0x%x %s (fsid %pU)\n", osd, w,
>> +                       w == CEPH_OSD_IN ? "(in)" :
>> +                       (w == CEPH_OSD_OUT ? "(out)" : ""),
>> +                       &map->fsid);
>>                  map->osd_weight[osd] = w;
>>
>>                  /*
>> @@ -1898,10 +1901,11 @@ static int decode_new_up_state_weight(void **p, void *end, u8 struct_v,
>>                  BUG_ON(osd >= map->max_osd);
>>                  if ((map->osd_state[osd] & CEPH_OSD_UP) &&
>>                      (xorstate & CEPH_OSD_UP))
>> -                       pr_info("osd%d down\n", osd);
>> +                       pr_info("osd%d down (fsid %pU)\n", osd, &map->fsid);
>>                  if ((map->osd_state[osd] & CEPH_OSD_EXISTS) &&
>>                      (xorstate & CEPH_OSD_EXISTS)) {
>> -                       pr_info("osd%d does not exist\n", osd);
>> +                       pr_info("osd%d does not exist (fsid %pU)\n", osd,
>> +                               &map->fsid);
>>                          ret = set_primary_affinity(map, osd,
>>                                                     CEPH_OSD_DEFAULT_PRIMARY_AFFINITY);
>>                          if (ret)
>> @@ -1929,9 +1933,10 @@ static int decode_new_up_state_weight(void **p, void *end, u8 struct_v,
>>                  if (ret)
>>                          return ret;
>>
>> -               dout("%s osd%d addr %s\n", __func__, osd, ceph_pr_addr(&addr));
>> +               dout("%s osd%d addr %s (fsid %pU)\n", __func__, osd,
>> +                    ceph_pr_addr(&addr), &map->fsid);
>>
>> -               pr_info("osd%d up\n", osd);
>> +               pr_info("osd%d up (fsid %pU)\n", osd, &map->fsid);
>>                  map->osd_state[osd] |= CEPH_OSD_EXISTS | CEPH_OSD_UP;
>>                  map->osd_addr[osd] = addr;
>>          }
>> --
>> 2.25.1
> 
> Hi Daichi,
> 
> I would suggest two things:
> 
> 1) Leave dout messages alone for now.  They aren't shown by default and
>     are there for developers to do debugging.  In that setting, multiple
>     clusters or client instances should be rare.

Sure, I'll leave dout messages alone.

> 2) For pr_info/pr_warn/etc messages, make the format consistent and
>     more grepable, e.g.
> 
>       libceph (<fsid> <gid>): <message>
> 
>       libceph (ef1ab157-688c-483b-a94d-0aeec9ca44e0 4181): osd10 down
> 
>     as I suggested earlier.  Sometimes printing just the fsid, sometimes
>     the fsid and the gid and sometimes none is undesirable.

Let me confirm two points:

- For consistency, should all pr_info/pr_warn/etc messages in libceph
   uses format with fsid and gid? Or does your suggestion means messages
   with osd or mon id (i.e. messages which I had edited in this patch)
   should have consistent format?

- What should be displayed if fsid or gid cannot be obtained? For example,
   we may not know fsid yet when establishing session with mon. Also,
   decode_new_up_state_weight() outputs message like "osd10 down" etc, but
   it seems not easy to get client gid within this function. This is why
   there are sometimes fsid only and sometimes gid only and sometimes both
   in my patch.

Thanks,
Daichi
