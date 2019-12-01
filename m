Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C6D510E2FE
	for <lists+ceph-devel@lfdr.de>; Sun,  1 Dec 2019 19:19:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727317AbfLASTe (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 1 Dec 2019 13:19:34 -0500
Received: from mtax.cdmx.gob.mx ([187.141.35.197]:8821 "EHLO mtax.cdmx.gob.mx"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727295AbfLASTe (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Sun, 1 Dec 2019 13:19:34 -0500
X-Greylist: delayed 6562 seconds by postgrey-1.27 at vger.kernel.org; Sun, 01 Dec 2019 13:19:33 EST
X-NAI-Header: Modified by McAfee Email Gateway (4500)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cdmx.gob.mx; s=72359050-3965-11E6-920A-0192F7A2F08E;
        t=1575217625; h=DKIM-Filter:X-Virus-Scanned:
         Content-Type:MIME-Version:Content-Transfer-Encoding:
         Content-Description:Subject:To:From:Date:Message-Id:
         X-AnalysisOut:X-AnalysisOut:X-AnalysisOut:
         X-AnalysisOut:X-AnalysisOut:X-SAAS-TrackingID:
         X-NAI-Spam-Flag:X-NAI-Spam-Threshold:X-NAI-Spam-Score:
         X-NAI-Spam-Rules:X-NAI-Spam-Version; bh=M
        8rWdUYQ57RAYAgTWJQ4Rsch0kO0UXllaAVDzocOs4
        8=; b=XKUYD+QS2r+9ZbHy5RpAVxj+pZnQC7Q7cTViWuyWHEXY
        QBbK2hb+KexqAWu9kpDFo36Pv8nFLKt3pypAeUXg64cTQwH/6B
        ppU70JgP3id15uNcl/nIdZFEpIK0DPEKoQhfrY4nQ5FnyK/obE
        jROpNjnOuviUSToqIagBLIRdgFM=
Received: from cdmx.gob.mx (correo.cdmx.gob.mx [10.250.108.150]) by mtax.cdmx.gob.mx with smtp
        (TLS: TLSv1/SSLv3,256bits,ECDHE-RSA-AES256-GCM-SHA384)
         id 1a22_50b8_b013406f_b356_481d_b307_7300debbb3ac;
        Sun, 01 Dec 2019 10:27:04 -0600
Received: from localhost (localhost [127.0.0.1])
        by cdmx.gob.mx (Postfix) with ESMTP id 432F61E2B15;
        Sun,  1 Dec 2019 10:18:40 -0600 (CST)
Received: from cdmx.gob.mx ([127.0.0.1])
        by localhost (cdmx.gob.mx [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id 927afmzW5ZGQ; Sun,  1 Dec 2019 10:18:40 -0600 (CST)
Received: from localhost (localhost [127.0.0.1])
        by cdmx.gob.mx (Postfix) with ESMTP id 611931E2504;
        Sun,  1 Dec 2019 10:13:45 -0600 (CST)
DKIM-Filter: OpenDKIM Filter v2.9.2 cdmx.gob.mx 611931E2504
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cdmx.gob.mx;
        s=72359050-3965-11E6-920A-0192F7A2F08E; t=1575216825;
        bh=M8rWdUYQ57RAYAgTWJQ4Rsch0kO0UXllaAVDzocOs48=;
        h=Content-Type:MIME-Version:Content-Transfer-Encoding:Subject:To:
         From:Date:Message-Id;
        b=u7/KnAkpJ9kaHwrs/hDNl2XxyhFvaNiaTmiQ55la1NH0Cf5uMQH+0e8RidQcLQPAs
         oUwuP0c+R9NdAEnZIkIWFc2j0CO3JBQQ1F/Lm64kIA0tLLDBE5WLizpHcqH2OuqMt5
         YIudnGLkelVe54qGy2DzXRt5/xDvg5KnPFz3fPZk=
X-Virus-Scanned: amavisd-new at cdmx.gob.mx
Received: from cdmx.gob.mx ([127.0.0.1])
        by localhost (cdmx.gob.mx [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 1_TH2OSVL7_a; Sun,  1 Dec 2019 10:13:45 -0600 (CST)
Received: from [192.168.0.104] (unknown [188.125.168.160])
        by cdmx.gob.mx (Postfix) with ESMTPSA id 586F01E313F;
        Sun,  1 Dec 2019 10:05:02 -0600 (CST)
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Description: Mail message body
Subject: Congratulations
To:     Recipients <aac-styfe@cdmx.gob.mx>
From:   "Bishop Johnr" <aac-styfe@cdmx.gob.mx>
Date:   Sun, 01 Dec 2019 17:04:55 +0100
Message-Id: <20191201160502.586F01E313F@cdmx.gob.mx>
X-AnalysisOut: [v=2.2 cv=cLaQihWN c=1 sm=1 tr=0 p=6K-Ig8iNAUou4E5wYCEA:9 p]
X-AnalysisOut: [=zRI05YRXt28A:10 a=T6zFoIZ12MK39YzkfxrL7A==:117 a=9152RP8M]
X-AnalysisOut: [6GQqDhC/mI/QXQ==:17 a=8nJEP1OIZ-IA:10 a=pxVhFHJ0LMsA:10 a=]
X-AnalysisOut: [pGLkceISAAAA:8 a=wPNLvfGTeEIA:10 a=M8O0W8wq6qAA:10 a=Ygvjr]
X-AnalysisOut: [iKHvHXA2FhpO6d-:22]
X-SAAS-TrackingID: 7d9e3ed5.0.90879470.00-2352.152483320.s12p02m012.mxlogic.net
X-NAI-Spam-Flag: NO
X-NAI-Spam-Threshold: 3
X-NAI-Spam-Score: -5000
X-NAI-Spam-Rules: 1 Rules triggered
        WHITELISTED=-5000
X-NAI-Spam-Version: 2.3.0.9418 : core <6686> : inlines <7165> : streams
 <1840193> : uri <2949750>
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Money was donated to you by Mr and Mrs Allen and Violet Large, just contact=
 them with this email for more information =


EMail: allenandvioletlargeaward@gmail.com
