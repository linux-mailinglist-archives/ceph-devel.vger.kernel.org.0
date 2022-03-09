Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E73EE4D267C
	for <lists+ceph-devel@lfdr.de>; Wed,  9 Mar 2022 05:05:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231571AbiCIDAQ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 8 Mar 2022 22:00:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231497AbiCIDAP (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 8 Mar 2022 22:00:15 -0500
Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01on2092.outbound.protection.outlook.com [40.107.255.92])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57B8F13687F
        for <ceph-devel@vger.kernel.org>; Tue,  8 Mar 2022 18:59:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IWatimgwD2LH9p7FWPvFTjop2M6LGd76RiSRir825GBAPvpWmFXx1izrkOm2uLwAgEmCllm9rQNAzDUPMyqXA5uJe0zEtm1kPdVyHcqw+yE2zdOH7G4YsPHm6JsDXyOLhrKxIDIcczBL02P19zctfaAr/HncCTkXj10W12aCTXyAfZPtv0Rq4SRfs9OrffJ/ONoNuszxQ0IcDou/1r4iW97+22SFuV/+Bca7DplBmsE8MYlal+yEAdMXyh7qL23nUggeKoeCNeCJsN5G0ggGz+t1gnAEYv4q1VV8wYGh099DDGMXiaqzXtOUpq9chKmy61wzP5IFUuqr9YK7WMfN1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nQivK6x8wIh29Nr53phkqU0uOOj3smvqpso2jNQNAKw=;
 b=ZAyQr5DQkHh8+khecqBvZsHI6w6my1PNXOTubfEEXlRjHVxEyFqHfXZqPOdf4XOgN9i9xsdJ3LWZUiN1tvhcOq0wsxIcmRnycSpFUg9h38kYaMB3ayCef0BhKlwqUeAWg9uQVY4JrmHd+gWqyneofGV1Sd6h7xyW3wBPL1bz6Fq8c/cmuyh9p/+dyriSRRJw2eCjd46amXjIOSTFgkckClhBqqXu4e00gZ7lzm9k89HgzYYDHq94xlP5OnlLpDjIDFSNYVmzImb7FqKxGvusNBPlEazYnVsrjrXR9hf0GsRv/mSbX2tr84YnHyeJ7BvxnWK6X5f9RwqKVlv4ECBQ+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cybozu.co.jp; dmarc=pass action=none header.from=cybozu.co.jp;
 dkim=pass header.d=cybozu.co.jp; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cybozu.co.jp;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nQivK6x8wIh29Nr53phkqU0uOOj3smvqpso2jNQNAKw=;
 b=Uzd6Fc6rFFXnkFZwACstvBbZ3Dlzdyz04M1Hh4yx2u5J7CfYY4WdqMyfHxD5ETbqUt0N6OZNlkXKD/c1+v6ugd1kduKgbICcROcMCMbkYZtGosXhKp2G5hPKjN8Fu4Hf4iyQo776laQAJRYvYEeY0DLMzTFCMdCLLk/GRvQmTqg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=cybozu.co.jp;
Received: from TY2PR03MB4254.apcprd03.prod.outlook.com (2603:1096:404:b1::17)
 by PSAPR03MB6394.apcprd03.prod.outlook.com (2603:1096:301:ae::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.7; Wed, 9 Mar
 2022 02:59:12 +0000
Received: from TY2PR03MB4254.apcprd03.prod.outlook.com
 ([fe80::3d2e:a17b:81d0:f38]) by TY2PR03MB4254.apcprd03.prod.outlook.com
 ([fe80::3d2e:a17b:81d0:f38%6]) with mapi id 15.20.5061.017; Wed, 9 Mar 2022
 02:59:12 +0000
Message-ID: <d0a7e3d1-f9ca-994e-fa6e-b730b443346d@cybozu.co.jp>
Date:   Wed, 9 Mar 2022 11:59:11 +0900
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.2
From:   Daichi Mukai <daichi-mukai@cybozu.co.jp>
Subject: [PATCH v2] libceph: print fsid and client gid with mon id and osd id
To:     ceph-devel@vger.kernel.org
Cc:     satoru.takeuchi@gmail.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TYAPR01CA0104.jpnprd01.prod.outlook.com
 (2603:1096:404:2a::20) To TY2PR03MB4254.apcprd03.prod.outlook.com
 (2603:1096:404:b1::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3fc4ac66-585b-461a-2f1b-08da0178c9c4
X-MS-TrafficTypeDiagnostic: PSAPR03MB6394:EE_
X-Microsoft-Antispam-PRVS: <PSAPR03MB6394B89104FAF5F5636652B6AC0A9@PSAPR03MB6394.apcprd03.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 96qH3zbnylSWpdlV7MfGBb8h9+L1lpitp9P7xEK/nmpQJRYaM3v+4GA0xX9a/Xq+yChX/2K9QseknAf+MRfmuTK/NDuNsJ5Fmdsa+2827bChdOKJ/YQmnTTJuDDRE2+fZcYn6u/38Lkr1EMGrKEaAoZ7m0s+LU5ouSgzqreBjNZG6L452l6aUQhIX1/jzTUzcFFwe+j5F4zdGPOEI25RuIOh5Kimy2bB7WZu1rU/0+6P/5XrWAIQi0HMu28ffygOQOBby9clIGPZOtka8aMrr0lorhmuw/XQTcF7jJ2FKr9cbt9aoOvjOndPtYIuc1zNWPeecfDR5vf5bLBLxKbB0/2s2RKkqIVbScdj304xNAbEmzYT/1mP+uNlRzICO4pjtDVtiHknSzwrrVFWmaGf7Qnmfa+r67YY9eZ4lCvQziPI77jwm8YEWNCkq/YfXWfScizRb00KARVC9H0ZzIPEkNDP7oMa+MLZGi7yzpJG/CyoeGEbmzydegpum3NR9v8PjBQiuDKfV7N5eZwBjLDzwN+/v8T2zV38rTp/bUTBHWbQwAh2F0PL/9LFGDFQftdgN6Fb1TiSOFyn+gpv2b6qgPnGi2ZD951j43Ap07Al4CyPMmGGGz6l9NSNOInT23q48XCwcFGaWt6AVXLQmikMfvmwMYk2IP3gk+x+xbu1qwpV0soY9tpG7Mjw50xUP7L+RbmKOXpuOjOqp7ZWXiv3PYNk2x/PVSPuAz27MIWaSprlXmFmCijPqiy1uqFyL680KqLAhiPd0RfQFPGvUE3AdBqpuoU1o8vrJc8KEHuSUm3E1vNHsqtgJPaZv7plyzkrAOFGe1l1O/F5vF4ohHQBLGCYf9Bh6OceTyf3kGNYMeA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY2PR03MB4254.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(31696002)(83380400001)(6512007)(6486002)(38100700002)(38350700002)(966005)(508600001)(6916009)(2616005)(186003)(31686004)(86362001)(26005)(36756003)(52116002)(6506007)(30864003)(2906002)(66476007)(66556008)(66946007)(316002)(8936002)(4326008)(5660300002)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SmxFd2U5VDRTRFdaNVVrYlZoZFNzNTVZMEYyNjl3NTJPR0JqbWZScS9EQjRW?=
 =?utf-8?B?c2JTVTB5OUloSlhBY053TDFHaVVmMHNwNGsrbVRDRXQvTlVaTExTR2dGcUNy?=
 =?utf-8?B?bkY1ckk3R2RxVmVmczRZUFNPMTB0RE5XaEp4bEJRYURRMndLVzFwcTBIc25B?=
 =?utf-8?B?QmVDN1FYNGV0bWtkRzN0NlJDb2RqVnkraUdwckVLT2JtaVkxRDVqL2wyR0cy?=
 =?utf-8?B?dDhPQnVBNWlKT3ZDVFFPbEwzNWtCNWlWek8xRHd6VUEzcWIwcS81MzU2ZnVs?=
 =?utf-8?B?VkpacElJSHg2MG1CRDcxNEprci9sSVdYNzhvNVloUm1ndk1uOW0vNWhQckxz?=
 =?utf-8?B?UW0zZEZFZnBmdHlvdVpRM2txQmJJL3ZVenlONW5oem1pYjA0NmVwTjhSWnEw?=
 =?utf-8?B?cVkrNm9FZDlGMVVxdXdEQmd5cnpKMWd4NncyL1JCbnFHd28ramV2ZjBZL1Vw?=
 =?utf-8?B?ZUdzNkk3N0hIb2JhYlNQQS9EOUVNa0pJSUpHdlRTYVY2MzNPUkxGSW1ud3V2?=
 =?utf-8?B?YWZKalZOZnRDcE5Zd0x1ZlQ5V3FOdFV0QWNzMmplbXVRMjdTNWpMUmh4cTdW?=
 =?utf-8?B?ZUsvRkQxTFZ5STZvNnBpNkNQenFZdkhkS0ZvUW1SaDg1U0p6amVFSCtvSEJ1?=
 =?utf-8?B?eXRSMzFoN3JYZ0N1NVo1WW5ra2FUV1JWUjJUYkM3d0Yvc1ZqV0VZYmZNbWQ5?=
 =?utf-8?B?K2Z2RFpNMmRkU050RThETmJPb0lST2xxWVRJaUY2U3QrSnRLaEpGaFBHSXFZ?=
 =?utf-8?B?dmZ6VmZlM1RBUHcwMHNPTVdSWVFoN2h1WUdjRXRPRW1OUUVnSm1YNTRYaHRL?=
 =?utf-8?B?TlJ6ZmoxTmY2Ti8wY1lYWGtsM2NlN1V1NzVwZmlsV2ljeU9ud3hHT3c0aURZ?=
 =?utf-8?B?aHFQVkNMYk9XUCs3ZUtvTDlKWkY2OW5UTk1yUERJS2J0OTZvUlQvWjlHbTU4?=
 =?utf-8?B?OHl6Qmt3YkVmM2Y1NUtkV2JNNy8vOStrdGU3MFhaMm5URVdsaDNRTTJTaDQy?=
 =?utf-8?B?bUVCWWpSUjh6NkJjZmhxWVV2SmVOYXJLVER1Ukl5cFBaOTRzTjd0bVVyMFFv?=
 =?utf-8?B?YXNvYTROZHRZL0ppTnhrQXRXOUxNTHBJZDloRUVBRDBhZXk1Z3lsblF4SlFq?=
 =?utf-8?B?MFp0OVAzcFY2VWlLcDF5aTdqY0ptTUpkc3RWdDBHNlVsRmREVjQ5TXNkV3FW?=
 =?utf-8?B?RDRxVVRINUU0UFB1a0NFR3crdzVTT0NkUzdWbk5hT1h3ZHpFbFRwRURnWXY0?=
 =?utf-8?B?SVRXSkFBajA3RG9acVR0aWRSNm00WEMxOS9sWG85b3B4VXRvQ0I3TEI0NjFB?=
 =?utf-8?B?UUtyVmQvREpjb09yR1lGTHN4WUI5QmwwZVBZRFZ0YUNMV3NBMy8rZ3Y2dnNk?=
 =?utf-8?B?VHpkNkg5VXh3T1dYMTBhdjBocHY2eWVhY2w4QVNDejRjR0I2ZXh1YUpzSVlO?=
 =?utf-8?B?R2ZtaXFhbDFYWjFZVTQ3YTVXZ2lsQVMvaDhldHlCSVlBYithVEFvTEw2MUNJ?=
 =?utf-8?B?ZU9nL2o2c0FGL244U3I0eWFiVDlGOWFRN1NZMm9tR1RuRGdZb2haNDhsOSs3?=
 =?utf-8?B?dm9wa2V3S08vS1dxR0tiQitlY2hJb0pzTUJBbGZzZU9DcjRoOGovUmhubnFr?=
 =?utf-8?B?cDgweVJ0cEZmblpPRUJmUDNZdGlsemtvelc1NlM4L2lraUQ2MEtDUHU1Kzh3?=
 =?utf-8?B?aWVDVXlzUTQzMFFPanJFa0o5K0VzSjQ4MnJiQm9PS2pEYWxIQU1aRzdjYy9E?=
 =?utf-8?B?NURieU9GM3JBZ3Q4ampSa3MwZHhURHFyRUNCR3gvN0FPSmc4bCsyTGx0RmxE?=
 =?utf-8?B?OHJ2MHRWaDFkZ2g0bnQwVk5EdEZaUTRsM0s1L1pFTm9TSVUrUG9aVnRXYm5I?=
 =?utf-8?B?SmliNEl3aXA1NDZVUDNqdzdFd01MdHVFNitsbWg2RVRHaUh5Y05mbVFERTgz?=
 =?utf-8?B?U2RMVURCSHRCMEtGMGRDMTQxZ1BtRUF6ZWF0RXJOeEFkOHZIL3dIUGF6WmdL?=
 =?utf-8?Q?JKGbhbv74iGB3y4sJ+rR6IfDAlAi2s=3D?=
X-OriginatorOrg: cybozu.co.jp
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fc4ac66-585b-461a-2f1b-08da0178c9c4
X-MS-Exchange-CrossTenant-AuthSource: TY2PR03MB4254.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2022 02:59:12.3971
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3761f390-05f7-4386-9a0b-b6806c13b841
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5eCQc2Sj09ubJkURrd7bbrdJgHSDQkaar/lYXn1BxJRFK/dodn9iHlyx0LTrYC1AmAi58KE/37tP4+vmem1ZRKFshcwR2ZM15lHEIwP+XhEJVwKx62MLC5bbpIFpOAh2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PSAPR03MB6394
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Print fsid and client gid in libceph log messages to distinct from which
each message come.

Signed-off-by: Satoru Takeuchi <satoru.takeuchi@gmail.com>
Signed-off-by: Daichi Mukai <daichi-mukai@cybozu.co.jp>

---
I took over Satoru's patch.
https://www.spinics.net/lists/ceph-devel/msg51932.html
---
  net/ceph/mon_client.c |  32 +++++---
  net/ceph/osd_client.c | 166 +++++++++++++++++++++++++++---------------
  net/ceph/osdmap.c     |  23 +++---
  3 files changed, 143 insertions(+), 78 deletions(-)

diff --git a/net/ceph/mon_client.c b/net/ceph/mon_client.c
index 6a6898ee4049..975a8d725e30 100644
--- a/net/ceph/mon_client.c
+++ b/net/ceph/mon_client.c
@@ -141,8 +141,8 @@ static struct ceph_monmap *ceph_monmap_decode(void **p, void *end, bool msgr2)
  		if (ret)
  			goto fail;
  
-		dout("%s mon%d addr %s\n", __func__, i,
-		     ceph_pr_addr(&inst->addr));
+		dout("%s mon%d addr %s (fsid %pU)\n", __func__, i,
+		     ceph_pr_addr(&inst->addr), &monmap->fsid);
  	}
  
  	return monmap;
@@ -187,7 +187,8 @@ static void __send_prepared_auth_request(struct ceph_mon_client *monc, int len)
   */
  static void __close_session(struct ceph_mon_client *monc)
  {
-	dout("__close_session closing mon%d\n", monc->cur_mon);
+	dout("__close_session closing mon%d (fsid %pU client%lld)\n",
+	     monc->cur_mon, &monc->client->fsid, ceph_client_gid(monc->client));
  	ceph_msg_revoke(monc->m_auth);
  	ceph_msg_revoke_incoming(monc->m_auth_reply);
  	ceph_msg_revoke(monc->m_subscribe);
@@ -229,8 +230,9 @@ static void pick_new_mon(struct ceph_mon_client *monc)
  		monc->cur_mon = n;
  	}
  
-	dout("%s mon%d -> mon%d out of %d mons\n", __func__, old_mon,
-	     monc->cur_mon, monc->monmap->num_mon);
+	dout("%s mon%d -> mon%d out of %d mons (fsid %pU client%lld)\n", __func__,
+	     old_mon, monc->cur_mon, monc->monmap->num_mon,
+	     &monc->client->fsid, ceph_client_gid(monc->client));
  }
  
  /*
@@ -252,7 +254,8 @@ static void __open_session(struct ceph_mon_client *monc)
  	monc->sub_renew_after = jiffies; /* i.e., expired */
  	monc->sub_renew_sent = 0;
  
-	dout("%s opening mon%d\n", __func__, monc->cur_mon);
+	dout("%s opening mon%d (fsid %pU client%lld)\n", __func__,
+	     monc->cur_mon, &monc->client->fsid, ceph_client_gid(monc->client));
  	ceph_con_open(&monc->con, CEPH_ENTITY_TYPE_MON, monc->cur_mon,
  		      &monc->monmap->mon_inst[monc->cur_mon].addr);
  
@@ -279,8 +282,9 @@ static void __open_session(struct ceph_mon_client *monc)
  static void reopen_session(struct ceph_mon_client *monc)
  {
  	if (!monc->hunting)
-		pr_info("mon%d %s session lost, hunting for new mon\n",
-		    monc->cur_mon, ceph_pr_addr(&monc->con.peer_addr));
+		pr_info("mon%d %s session lost, hunting for new mon (fsid %pU client%lld)\n",
+			monc->cur_mon, ceph_pr_addr(&monc->con.peer_addr),
+			&monc->client->fsid, ceph_client_gid(monc->client));
  
  	__close_session(monc);
  	__open_session(monc);
@@ -1263,7 +1267,9 @@ EXPORT_SYMBOL(ceph_monc_stop);
  static void finish_hunting(struct ceph_mon_client *monc)
  {
  	if (monc->hunting) {
-		dout("%s found mon%d\n", __func__, monc->cur_mon);
+		dout("%s found mon%d (fsid %pU client%lld)\n", __func__,
+		     monc->cur_mon, &monc->client->fsid,
+		     ceph_client_gid(monc->client));
  		monc->hunting = false;
  		monc->had_a_connection = true;
  		un_backoff(monc);
@@ -1295,8 +1301,9 @@ static void finish_auth(struct ceph_mon_client *monc, int auth_err,
  		__send_subscribe(monc);
  		__resend_generic_request(monc);
  
-		pr_info("mon%d %s session established\n", monc->cur_mon,
-			ceph_pr_addr(&monc->con.peer_addr));
+		pr_info("mon%d %s session established (client%lld)\n",
+			monc->cur_mon, ceph_pr_addr(&monc->con.peer_addr),
+			ceph_client_gid(monc->client));
  	}
  }
  
@@ -1546,7 +1553,8 @@ static void mon_fault(struct ceph_connection *con)
  	struct ceph_mon_client *monc = con->private;
  
  	mutex_lock(&monc->mutex);
-	dout("%s mon%d\n", __func__, monc->cur_mon);
+	dout("%s mon%d (fsid %pU client%lld)\n", __func__,
+	     monc->cur_mon, &monc->client->fsid, ceph_client_gid(monc->client));
  	if (monc->cur_mon >= 0) {
  		if (!monc->hunting) {
  			dout("%s hunting for new mon\n", __func__);
diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index 1c5815530e0d..04d859c04972 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -1271,7 +1271,8 @@ static void __move_osd_to_lru(struct ceph_osd *osd)
  {
  	struct ceph_osd_client *osdc = osd->o_osdc;
  
-	dout("%s osd %p osd%d\n", __func__, osd, osd->o_osd);
+	dout("%s osd %p osd%d (fsid %pU client%lld)\n", __func__, osd,
+	     osd->o_osd, &osdc->client->fsid, ceph_client_gid(osdc->client));
  	BUG_ON(!list_empty(&osd->o_osd_lru));
  
  	spin_lock(&osdc->osd_lru_lock);
@@ -1292,7 +1293,8 @@ static void __remove_osd_from_lru(struct ceph_osd *osd)
  {
  	struct ceph_osd_client *osdc = osd->o_osdc;
  
-	dout("%s osd %p osd%d\n", __func__, osd, osd->o_osd);
+	dout("%s osd %p osd%d (fsid %pU client%lld)\n", __func__, osd,
+	     osd->o_osd, &osdc->client->fsid, ceph_client_gid(osdc->client));
  
  	spin_lock(&osdc->osd_lru_lock);
  	if (!list_empty(&osd->o_osd_lru))
@@ -1310,7 +1312,8 @@ static void close_osd(struct ceph_osd *osd)
  	struct rb_node *n;
  
  	verify_osdc_wrlocked(osdc);
-	dout("%s osd %p osd%d\n", __func__, osd, osd->o_osd);
+	dout("%s osd %p osd%d (fsid %pU client%lld)\n", __func__, osd,
+	     osd->o_osd, &osdc->client->fsid, ceph_client_gid(osdc->client));
  
  	ceph_con_close(&osd->o_con);
  
@@ -1347,9 +1350,11 @@ static void close_osd(struct ceph_osd *osd)
   */
  static int reopen_osd(struct ceph_osd *osd)
  {
+	struct ceph_osd_client *osdc = osd->o_osdc;
  	struct ceph_entity_addr *peer_addr;
  
-	dout("%s osd %p osd%d\n", __func__, osd, osd->o_osd);
+	dout("%s osd %p osd%d (fsid %pU client%lld)\n", __func__, osd,
+	     osd->o_osd, &osdc->client->fsid, ceph_client_gid(osdc->client));
  
  	if (RB_EMPTY_ROOT(&osd->o_requests) &&
  	    RB_EMPTY_ROOT(&osd->o_linger_requests)) {
@@ -1357,7 +1362,7 @@ static int reopen_osd(struct ceph_osd *osd)
  		return -ENODEV;
  	}
  
-	peer_addr = &osd->o_osdc->osdmap->osd_addr[osd->o_osd];
+	peer_addr = &osdc->osdmap->osd_addr[osd->o_osd];
  	if (!memcmp(peer_addr, &osd->o_con.peer_addr, sizeof (*peer_addr)) &&
  			!ceph_con_opened(&osd->o_con)) {
  		struct rb_node *n;
@@ -1405,7 +1410,8 @@ static struct ceph_osd *lookup_create_osd(struct ceph_osd_client *osdc, int o,
  			      &osdc->osdmap->osd_addr[osd->o_osd]);
  	}
  
-	dout("%s osdc %p osd%d -> osd %p\n", __func__, osdc, o, osd);
+	dout("%s osdc %p osd%d -> osd %p (fsid %pU client%lld)\n", __func__,
+	     osdc, o, osd, &osdc->client->fsid, ceph_client_gid(osdc->client));
  	return osd;
  }
  
@@ -1416,15 +1422,18 @@ static struct ceph_osd *lookup_create_osd(struct ceph_osd_client *osdc, int o,
   */
  static void link_request(struct ceph_osd *osd, struct ceph_osd_request *req)
  {
+	struct ceph_osd_client *osdc = osd->o_osdc;
+
  	verify_osd_locked(osd);
  	WARN_ON(!req->r_tid || req->r_osd);
-	dout("%s osd %p osd%d req %p tid %llu\n", __func__, osd, osd->o_osd,
-	     req, req->r_tid);
+	dout("%s osd %p osd%d req %p tid %llu (fsid %pU client%lld)\n",
+	     __func__, osd, osd->o_osd, req, req->r_tid, &osdc->client->fsid,
+	     ceph_client_gid(osdc->client));
  
  	if (!osd_homeless(osd))
  		__remove_osd_from_lru(osd);
  	else
-		atomic_inc(&osd->o_osdc->num_homeless);
+		atomic_inc(&osdc->num_homeless);
  
  	get_osd(osd);
  	insert_request(&osd->o_requests, req);
@@ -1433,10 +1442,13 @@ static void link_request(struct ceph_osd *osd, struct ceph_osd_request *req)
  
  static void unlink_request(struct ceph_osd *osd, struct ceph_osd_request *req)
  {
+	struct ceph_osd_client *osdc = osd->o_osdc;
+
  	verify_osd_locked(osd);
  	WARN_ON(req->r_osd != osd);
-	dout("%s osd %p osd%d req %p tid %llu\n", __func__, osd, osd->o_osd,
-	     req, req->r_tid);
+	dout("%s osd %p osd%d req %p tid %llu (fsid %pU client%lld)\n",
+	     __func__, osd, osd->o_osd, req, req->r_tid, &osdc->client->fsid,
+	     ceph_client_gid(osdc->client));
  
  	req->r_osd = NULL;
  	erase_request(&osd->o_requests, req);
@@ -1445,7 +1457,7 @@ static void unlink_request(struct ceph_osd *osd, struct ceph_osd_request *req)
  	if (!osd_homeless(osd))
  		maybe_move_osd_to_lru(osd);
  	else
-		atomic_dec(&osd->o_osdc->num_homeless);
+		atomic_dec(&osdc->num_homeless);
  }
  
  static bool __pool_full(struct ceph_pg_pool_info *pi)
@@ -1532,8 +1544,9 @@ static int pick_closest_replica(struct ceph_osd_client *osdc,
  		}
  	} while (++i < acting->size);
  
-	dout("%s picked osd%d with locality %d, primary osd%d\n", __func__,
-	     acting->osds[best_i], best_locality, acting->primary);
+	dout("%s picked osd%d with locality %d, primary osd%d (fsid %pU client%lld)\n",
+	     __func__, acting->osds[best_i], best_locality, acting->primary,
+	     &osdc->client->fsid, ceph_client_gid(osdc->client));
  	return best_i;
  }
  
@@ -1666,8 +1679,10 @@ static enum calc_target_result calc_target(struct ceph_osd_client *osdc,
  		ct_res = CALC_TARGET_NO_ACTION;
  
  out:
-	dout("%s t %p -> %d%d%d%d ct_res %d osd%d\n", __func__, t, unpaused,
-	     legacy_change, force_resend, split, ct_res, t->osd);
+	dout("%s t %p -> %d%d%d%d ct_res %d osd%d (fsid %pU client%lld)\n",
+	     __func__, t, unpaused, legacy_change, force_resend, split,
+	     ct_res, t->osd, &osdc->client->fsid,
+	     ceph_client_gid(osdc->client));
  	return ct_res;
  }
  
@@ -1987,9 +2002,10 @@ static bool should_plug_request(struct ceph_osd_request *req)
  	if (!backoff)
  		return false;
  
-	dout("%s req %p tid %llu backoff osd%d spgid %llu.%xs%d id %llu\n",
-	     __func__, req, req->r_tid, osd->o_osd, backoff->spgid.pgid.pool,
-	     backoff->spgid.pgid.seed, backoff->spgid.shard, backoff->id);
+	dout("%s req %p tid %llu backoff osd%d spgid %llu.%xs%d id %llu (fsid %pU client%lld)\n",
+	     __func__,  req, req->r_tid, osd->o_osd, backoff->spgid.pgid.pool,
+	     backoff->spgid.pgid.seed, backoff->spgid.shard, backoff->id,
+	     &osd->o_osdc->client->fsid, ceph_client_gid(osd->o_osdc->client));
  	return true;
  }
  
@@ -2296,11 +2312,12 @@ static void send_request(struct ceph_osd_request *req)
  
  	encode_request_partial(req, req->r_request);
  
-	dout("%s req %p tid %llu to pgid %llu.%x spgid %llu.%xs%d osd%d e%u flags 0x%x attempt %d\n",
+	dout("%s req %p tid %llu to pgid %llu.%x spgid %llu.%xs%d osd%d e%u flags 0x%x attempt %d (fsid %pU client%lld)\n",
  	     __func__, req, req->r_tid, req->r_t.pgid.pool, req->r_t.pgid.seed,
  	     req->r_t.spgid.pgid.pool, req->r_t.spgid.pgid.seed,
-	     req->r_t.spgid.shard, osd->o_osd, req->r_t.epoch, req->r_flags,
-	     req->r_attempts);
+	     req->r_t.spgid.shard, osd->o_osd,
+	     req->r_t.epoch, req->r_flags, req->r_attempts,
+	     &osd->o_osdc->client->fsid, ceph_client_gid(osd->o_osdc->client));
  
  	req->r_t.paused = false;
  	req->r_stamp = jiffies;
@@ -2788,8 +2805,9 @@ static void link_linger(struct ceph_osd *osd,
  {
  	verify_osd_locked(osd);
  	WARN_ON(!lreq->linger_id || lreq->osd);
-	dout("%s osd %p osd%d lreq %p linger_id %llu\n", __func__, osd,
-	     osd->o_osd, lreq, lreq->linger_id);
+	dout("%s osd %p osd%d lreq %p linger_id %llu (fsid %pU client%lld)\n",
+	     __func__, osd, osd->o_osd, lreq, lreq->linger_id,
+	     &osd->o_osdc->client->fsid, ceph_client_gid(osd->o_osdc->client));
  
  	if (!osd_homeless(osd))
  		__remove_osd_from_lru(osd);
@@ -2806,8 +2824,9 @@ static void unlink_linger(struct ceph_osd *osd,
  {
  	verify_osd_locked(osd);
  	WARN_ON(lreq->osd != osd);
-	dout("%s osd %p osd%d lreq %p linger_id %llu\n", __func__, osd,
-	     osd->o_osd, lreq, lreq->linger_id);
+	dout("%s osd %p osd%d lreq %p linger_id %llu  (fsid %pU client%lld)\n",
+	     __func__, osd, osd->o_osd, lreq, lreq->linger_id,
+	     &osd->o_osdc->client->fsid, ceph_client_gid(osd->o_osdc->client));
  
  	lreq->osd = NULL;
  	erase_linger(&osd->o_linger_requests, lreq);
@@ -3357,14 +3376,18 @@ static void handle_timeout(struct work_struct *work)
  			p = rb_next(p); /* abort_request() */
  
  			if (time_before(req->r_stamp, cutoff)) {
-				dout(" req %p tid %llu on osd%d is laggy\n",
-				     req, req->r_tid, osd->o_osd);
+				dout(" req %p tid %llu on osd%d is laggy (fsid %pU client%lld)\n",
+				     req, req->r_tid, osd->o_osd,
+				     &osdc->client->fsid,
+				     ceph_client_gid(osdc->client));
  				found = true;
  			}
  			if (opts->osd_request_timeout &&
  			    time_before(req->r_start_stamp, expiry_cutoff)) {
-				pr_err_ratelimited("tid %llu on osd%d timeout\n",
-				       req->r_tid, osd->o_osd);
+				pr_err_ratelimited("tid %llu on osd%d timeout (fsid %pU client%lld)\n",
+				       req->r_tid, osd->o_osd,
+				       &osdc->client->fsid,
+				       ceph_client_gid(osdc->client));
  				abort_request(req, -ETIMEDOUT);
  			}
  		}
@@ -3372,8 +3395,10 @@ static void handle_timeout(struct work_struct *work)
  			struct ceph_osd_linger_request *lreq =
  			    rb_entry(p, struct ceph_osd_linger_request, node);
  
-			dout(" lreq %p linger_id %llu is served by osd%d\n",
-			     lreq, lreq->linger_id, osd->o_osd);
+			dout(" lreq %p linger_id %llu is served by osd%d (fsid %pU client%lld)\n",
+			     lreq, lreq->linger_id, osd->o_osd,
+			     &osdc->client->fsid,
+			     ceph_client_gid(osdc->client));
  			found = true;
  
  			mutex_lock(&lreq->lock);
@@ -3394,8 +3419,10 @@ static void handle_timeout(struct work_struct *work)
  			p = rb_next(p); /* abort_request() */
  
  			if (time_before(req->r_start_stamp, expiry_cutoff)) {
-				pr_err_ratelimited("tid %llu on osd%d timeout\n",
-				       req->r_tid, osdc->homeless_osd.o_osd);
+				pr_err_ratelimited("tid %llu on osd%d timeout (fsid %pU client%lld)\n",
+				       req->r_tid, osdc->homeless_osd.o_osd,
+				       &osdc->client->fsid,
+				       ceph_client_gid(osdc->client));
  				abort_request(req, -ETIMEDOUT);
  			}
  		}
@@ -3662,7 +3689,9 @@ static void handle_reply(struct ceph_osd *osd, struct ceph_msg *msg)
  
  	down_read(&osdc->lock);
  	if (!osd_registered(osd)) {
-		dout("%s osd%d unknown\n", __func__, osd->o_osd);
+		dout("%s osd%d unknown (fsid %pU client%lld)\n", __func__,
+		     osd->o_osd, &osd->o_osdc->client->fsid,
+		     ceph_client_gid(osdc->client));
  		goto out_unlock_osdc;
  	}
  	WARN_ON(osd->o_osd != le64_to_cpu(msg->hdr.src.num));
@@ -3670,7 +3699,9 @@ static void handle_reply(struct ceph_osd *osd, struct ceph_msg *msg)
  	mutex_lock(&osd->lock);
  	req = lookup_request(&osd->o_requests, tid);
  	if (!req) {
-		dout("%s osd%d tid %llu unknown\n", __func__, osd->o_osd, tid);
+		dout("%s osd%d tid %llu unknown (fsid %pU client%lld)\n",
+		     __func__, osd->o_osd, tid, &osd->o_osdc->client->fsid,
+		     ceph_client_gid(osdc->client));
  		goto out_unlock_session;
  	}
  
@@ -4180,11 +4211,14 @@ static void osd_fault(struct ceph_connection *con)
  	struct ceph_osd *osd = con->private;
  	struct ceph_osd_client *osdc = osd->o_osdc;
  
-	dout("%s osd %p osd%d\n", __func__, osd, osd->o_osd);
+	dout("%s osd %p osd%d (fsid %pU client%lld)\n", __func__, osd,
+	     osd->o_osd, &osdc->client->fsid, ceph_client_gid(osdc->client));
  
  	down_write(&osdc->lock);
  	if (!osd_registered(osd)) {
-		dout("%s osd%d unknown\n", __func__, osd->o_osd);
+		dout("%s osd%d unknown (fsid %pU client%lld)\n", __func__,
+		     osd->o_osd, &osdc->client->fsid,
+		     ceph_client_gid(osdc->client));
  		goto out_unlock;
  	}
  
@@ -4299,8 +4333,10 @@ static void handle_backoff_block(struct ceph_osd *osd, struct MOSDBackoff *m)
  	struct ceph_osd_backoff *backoff;
  	struct ceph_msg *msg;
  
-	dout("%s osd%d spgid %llu.%xs%d id %llu\n", __func__, osd->o_osd,
-	     m->spgid.pgid.pool, m->spgid.pgid.seed, m->spgid.shard, m->id);
+	dout("%s osd%d spgid %llu.%xs%d id %llu (fsid %pU client%lld)\n",
+	     __func__, osd->o_osd, m->spgid.pgid.pool, m->spgid.pgid.seed,
+	     m->spgid.shard, m->id, &osd->o_osdc->client->fsid,
+	     ceph_client_gid(osd->o_osdc->client));
  
  	spg = lookup_spg_mapping(&osd->o_backoff_mappings, &m->spgid);
  	if (!spg) {
@@ -4359,22 +4395,28 @@ static void handle_backoff_unblock(struct ceph_osd *osd,
  	struct ceph_osd_backoff *backoff;
  	struct rb_node *n;
  
-	dout("%s osd%d spgid %llu.%xs%d id %llu\n", __func__, osd->o_osd,
-	     m->spgid.pgid.pool, m->spgid.pgid.seed, m->spgid.shard, m->id);
+	dout("%s osd%d spgid %llu.%xs%d id %llu (fsid %pU client%lld)\n",
+	     __func__, osd->o_osd, m->spgid.pgid.pool, m->spgid.pgid.seed,
+	     m->spgid.shard, m->id, &osd->o_osdc->client->fsid,
+	     ceph_client_gid(osd->o_osdc->client));
  
  	backoff = lookup_backoff_by_id(&osd->o_backoffs_by_id, m->id);
  	if (!backoff) {
-		pr_err("%s osd%d spgid %llu.%xs%d id %llu backoff dne\n",
+		pr_err("%s osd%d spgid %llu.%xs%d id %llu backoff dne (fsid %pU client%lld)\n",
  		       __func__, osd->o_osd, m->spgid.pgid.pool,
-		       m->spgid.pgid.seed, m->spgid.shard, m->id);
+		       m->spgid.pgid.seed, m->spgid.shard, m->id,
+		       &osd->o_osdc->client->fsid,
+		       ceph_client_gid(osd->o_osdc->client));
  		return;
  	}
  
  	if (hoid_compare(backoff->begin, m->begin) &&
  	    hoid_compare(backoff->end, m->end)) {
-		pr_err("%s osd%d spgid %llu.%xs%d id %llu bad range?\n",
+		pr_err("%s osd%d spgid %llu.%xs%d id %llu bad range? (fsid %pU client%lld)\n",
  		       __func__, osd->o_osd, m->spgid.pgid.pool,
-		       m->spgid.pgid.seed, m->spgid.shard, m->id);
+		       m->spgid.pgid.seed, m->spgid.shard, m->id,
+		       &osd->o_osdc->client->fsid,
+		       ceph_client_gid(osd->o_osdc->client));
  		/* unblock it anyway... */
  	}
  
@@ -4418,7 +4460,9 @@ static void handle_backoff(struct ceph_osd *osd, struct ceph_msg *msg)
  
  	down_read(&osdc->lock);
  	if (!osd_registered(osd)) {
-		dout("%s osd%d unknown\n", __func__, osd->o_osd);
+		dout("%s osd%d unknown (fsid %pU client%lld)\n", __func__,
+		     osd->o_osd, &osd->o_osdc->client->fsid,
+		     ceph_client_gid(osdc->client));
  		up_read(&osdc->lock);
  		return;
  	}
@@ -4440,7 +4484,9 @@ static void handle_backoff(struct ceph_osd *osd, struct ceph_msg *msg)
  		handle_backoff_unblock(osd, &m);
  		break;
  	default:
-		pr_err("%s osd%d unknown op %d\n", __func__, osd->o_osd, m.op);
+		pr_err("%s osd%d unknown op %d (fsid %pU client%lld)\n",
+		       __func__, osd->o_osd, m.op, &osd->o_osdc->client->fsid,
+		       ceph_client_gid(osdc->client));
  	}
  
  	free_hoid(m.begin);
@@ -5417,7 +5463,9 @@ static struct ceph_msg *get_reply(struct ceph_connection *con,
  
  	down_read(&osdc->lock);
  	if (!osd_registered(osd)) {
-		dout("%s osd%d unknown, skipping\n", __func__, osd->o_osd);
+		dout("%s osd%d unknown, skipping (fsid %pU client%lld)\n",
+		     __func__, osd->o_osd, &osdc->client->fsid,
+		     ceph_client_gid(osdc->client));
  		*skip = 1;
  		goto out_unlock_osdc;
  	}
@@ -5426,8 +5474,9 @@ static struct ceph_msg *get_reply(struct ceph_connection *con,
  	mutex_lock(&osd->lock);
  	req = lookup_request(&osd->o_requests, tid);
  	if (!req) {
-		dout("%s osd%d tid %llu unknown, skipping\n", __func__,
-		     osd->o_osd, tid);
+		dout("%s osd%d tid %llu unknown, skipping (fsid %pU client%lld)\n",
+		     __func__, osd->o_osd, tid, &osdc->client->fsid,
+		     ceph_client_gid(osdc->client));
  		*skip = 1;
  		goto out_unlock_session;
  	}
@@ -5435,9 +5484,10 @@ static struct ceph_msg *get_reply(struct ceph_connection *con,
  	ceph_msg_revoke_incoming(req->r_reply);
  
  	if (front_len > req->r_reply->front_alloc_len) {
-		pr_warn("%s osd%d tid %llu front %d > preallocated %d\n",
+		pr_warn("%s osd%d tid %llu front %d > preallocated %d (fsid %pU client%lld)\n",
  			__func__, osd->o_osd, req->r_tid, front_len,
-			req->r_reply->front_alloc_len);
+			req->r_reply->front_alloc_len, &osdc->client->fsid,
+			ceph_client_gid(osdc->client));
  		m = ceph_msg_new(CEPH_MSG_OSD_OPREPLY, front_len, GFP_NOFS,
  				 false);
  		if (!m)
@@ -5447,9 +5497,10 @@ static struct ceph_msg *get_reply(struct ceph_connection *con,
  	}
  
  	if (data_len > req->r_reply->data_length) {
-		pr_warn("%s osd%d tid %llu data %d > preallocated %zu, skipping\n",
+		pr_warn("%s osd%d tid %llu data %d > preallocated %zu, skipping (fsid %pU client%lld)\n",
  			__func__, osd->o_osd, req->r_tid, data_len,
-			req->r_reply->data_length);
+			req->r_reply->data_length, &osdc->client->fsid,
+			ceph_client_gid(osdc->client));
  		m = NULL;
  		*skip = 1;
  		goto out_unlock_session;
@@ -5508,8 +5559,9 @@ static struct ceph_msg *osd_alloc_msg(struct ceph_connection *con,
  	case CEPH_MSG_OSD_OPREPLY:
  		return get_reply(con, hdr, skip);
  	default:
-		pr_warn("%s osd%d unknown msg type %d, skipping\n", __func__,
-			osd->o_osd, type);
+		pr_warn("%s osd%d unknown msg type %d, skipping (fsid %pU client%lld)\n",
+			__func__, osd->o_osd, type, &osd->o_osdc->client->fsid,
+			ceph_client_gid(osd->o_osdc->client));
  		*skip = 1;
  		return NULL;
  	}
diff --git a/net/ceph/osdmap.c b/net/ceph/osdmap.c
index 2823bb3cff55..a9cbd8b88929 100644
--- a/net/ceph/osdmap.c
+++ b/net/ceph/osdmap.c
@@ -1566,7 +1566,8 @@ static int decode_new_primary_affinity(void **p, void *end,
  		if (ret)
  			return ret;
  
-		pr_info("osd%d primary-affinity 0x%x\n", osd, aff);
+		pr_info("osd%d primary-affinity 0x%x (fsid %pU)\n", osd, aff,
+			&map->fsid);
  	}
  
  	return 0;
@@ -1728,7 +1729,8 @@ static int osdmap_decode(void **p, void *end, bool msgr2,
  		if (err)
  			goto bad;
  
-		dout("%s osd%d addr %s\n", __func__, i, ceph_pr_addr(addr));
+		dout("%s osd%d addr %s (fsid %pU)\n", __func__, i,
+		     ceph_pr_addr(addr), &map->fsid);
  	}
  
  	/* pg_temp */
@@ -1864,9 +1866,10 @@ static int decode_new_up_state_weight(void **p, void *end, u8 struct_v,
  		osd = ceph_decode_32(p);
  		w = ceph_decode_32(p);
  		BUG_ON(osd >= map->max_osd);
-		pr_info("osd%d weight 0x%x %s\n", osd, w,
-		     w == CEPH_OSD_IN ? "(in)" :
-		     (w == CEPH_OSD_OUT ? "(out)" : ""));
+		pr_info("osd%d weight 0x%x %s (fsid %pU)\n", osd, w,
+			w == CEPH_OSD_IN ? "(in)" :
+			(w == CEPH_OSD_OUT ? "(out)" : ""),
+			&map->fsid);
  		map->osd_weight[osd] = w;
  
  		/*
@@ -1898,10 +1901,11 @@ static int decode_new_up_state_weight(void **p, void *end, u8 struct_v,
  		BUG_ON(osd >= map->max_osd);
  		if ((map->osd_state[osd] & CEPH_OSD_UP) &&
  		    (xorstate & CEPH_OSD_UP))
-			pr_info("osd%d down\n", osd);
+			pr_info("osd%d down (fsid %pU)\n", osd, &map->fsid);
  		if ((map->osd_state[osd] & CEPH_OSD_EXISTS) &&
  		    (xorstate & CEPH_OSD_EXISTS)) {
-			pr_info("osd%d does not exist\n", osd);
+			pr_info("osd%d does not exist (fsid %pU)\n", osd,
+				&map->fsid);
  			ret = set_primary_affinity(map, osd,
  						   CEPH_OSD_DEFAULT_PRIMARY_AFFINITY);
  			if (ret)
@@ -1929,9 +1933,10 @@ static int decode_new_up_state_weight(void **p, void *end, u8 struct_v,
  		if (ret)
  			return ret;
  
-		dout("%s osd%d addr %s\n", __func__, osd, ceph_pr_addr(&addr));
+		dout("%s osd%d addr %s (fsid %pU)\n", __func__, osd,
+		     ceph_pr_addr(&addr), &map->fsid);
  
-		pr_info("osd%d up\n", osd);
+		pr_info("osd%d up (fsid %pU)\n", osd, &map->fsid);
  		map->osd_state[osd] |= CEPH_OSD_EXISTS | CEPH_OSD_UP;
  		map->osd_addr[osd] = addr;
  	}
-- 
2.25.1
