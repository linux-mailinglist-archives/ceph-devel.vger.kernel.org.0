Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5F327908C6
	for <lists+ceph-devel@lfdr.de>; Sat,  2 Sep 2023 18:58:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234803AbjIBQ63 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 2 Sep 2023 12:58:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230113AbjIBQ62 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sat, 2 Sep 2023 12:58:28 -0400
X-Greylist: delayed 8132 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 02 Sep 2023 09:58:21 PDT
Received: from GW_MAIL_PINTANA.pintana.cl (mail2.pintana.cl [200.27.210.227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90E78E40
        for <ceph-devel@vger.kernel.org>; Sat,  2 Sep 2023 09:58:21 -0700 (PDT)
Received: from mail.pintana.cl ([192.168.200.24])
        by GW_MAIL_PINTANA.pintana.cl  with ESMTP id 382EdhjU024531-382EdhjW024531
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Sat, 2 Sep 2023 10:39:44 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
        by mail.pintana.cl (Postfix) with ESMTP id A04C58AE103A;
        Sat,  2 Sep 2023 10:39:43 -0400 (-04)
Received: from mail.pintana.cl ([127.0.0.1])
        by localhost (mail.pintana.cl [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id PMrmvC1-rst7; Sat,  2 Sep 2023 10:39:43 -0400 (-04)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by mail.pintana.cl (Postfix) with ESMTP id 3A1AA8AE0079;
        Sat,  2 Sep 2023 10:39:43 -0400 (-04)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.pintana.cl 3A1AA8AE0079
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pintana.cl;
        s=C381F212-208E-11EC-BFD3-4D350E16814F; t=1693665583;
        bh=PrSDQ4FEvN8iyYo66zHSMQi7wfk+OSgnX0LG41XbL90=;
        h=MIME-Version:To:From:Date:Message-Id;
        b=TNlzOnNUxMZjZ+Bq2edr8xleucsb4cNBpIlCwuQ8KKW8iAxucD22tvF7663R4uPSL
         4hJZU3LcLcafvITyVHp05EdkOM6m3bLSeQBIoqqrr2WD+3malthueIu2++/o4Sm+sE
         ZSwrvql/QeYYxpblyT+Acvg4mzY61IoJWMU1YbtqXSyZIPpSZjLYbjewwGC9Lyi0IK
         Xu1VIlX179FHX7WRL4jp8YHq8IG+Zg3HvXPSxBE8k1Bot7TYMVrv8cpbxyvrDvnpyW
         LVn+kP8qv8F8rWmRBFd7EfGWJTER75CQZ5gHzUlDBsbRzh7wOU2TSVJ2iqn3v+RLdH
         JetlKDvAfGuGw==
X-Virus-Scanned: amavisd-new at pintana.cl
Received: from mail.pintana.cl ([127.0.0.1])
        by localhost (mail.pintana.cl [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id AE0_Mo24pd27; Sat,  2 Sep 2023 10:39:43 -0400 (-04)
Received: from [172.20.10.10] (unknown [197.210.8.33])
        by mail.pintana.cl (Postfix) with ESMTPSA id BA5F48AE0FD7;
        Sat,  2 Sep 2023 10:38:51 -0400 (-04)
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Description: Mail message body
Subject: =?utf-8?q?G=C3=B6khan_Burcu=2E?=
To:     Recipients <ana.ruz@pintana.cl>
From:   ana.ruz@pintana.cl
Date:   Sat, 02 Sep 2023 09:37:52 -0500
Reply-To: gokhanburcu091@gmail.com
Message-Id: <20230902143851.BA5F48AE0FD7@mail.pintana.cl>
X-FE-Policy-ID: 1:3:2:SYSTEM
X-Spam-Status: Yes, score=5.1 required=5.0 tests=BAYES_95,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FORGED_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: *  0.0 RCVD_IN_DNSWL_BLOCKED RBL: ADMINISTRATOR NOTICE: The query to
        *      DNSWL was blocked.  See
        *      http://wiki.apache.org/spamassassin/DnsBlocklists#dnsbl-block
        *      for more information.
        *      [200.27.210.227 listed in list.dnswl.org]
        *  3.0 BAYES_95 BODY: Bayes spam probability is 95 to 99%
        *      [score: 0.9845]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [gokhanburcu091[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        *  2.1 FREEMAIL_FORGED_REPLYTO Freemail in Reply-To, but not From
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hello, my name is G=F6khan Burcu. I am a widow from Turkey and I am very si=
ck with chronic cancer and the doctor said I have not more than 2 more mont=
hs to live. I am contacting you because now I need someone to help me compl=
ete my last mission here on earth before I go and join my husband in heaven=
. Can I trust you? In this case money is not a problem and you will highly =
benefit from this as well but can I trust you? if yes contact my email gokh=
anburcu091@gmail.com

G=F6khan Burcu.
