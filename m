Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1EBD76B868
	for <lists+ceph-devel@lfdr.de>; Tue,  1 Aug 2023 17:19:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232363AbjHAPTt convert rfc822-to-8bit (ORCPT
        <rfc822;lists+ceph-devel@lfdr.de>); Tue, 1 Aug 2023 11:19:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231720AbjHAPTs (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 1 Aug 2023 11:19:48 -0400
X-Greylist: delayed 1802 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 01 Aug 2023 08:19:46 PDT
Received: from newsmg.ebi.com.tr (webmail.sctlab.io [31.25.168.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6E88D10F5
        for <ceph-devel@vger.kernel.org>; Tue,  1 Aug 2023 08:19:46 -0700 (PDT)
X-AuditID: ac1f0a62-42bff70000001f25-84-64c916b4d537
Received: from [10.1.18.47] (185.253.162.3) by EGUVENEX.EGUVEN.LOCAL
 (192.168.127.11) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Tue, 1 Aug
 2023 04:11:16 +0300
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Description: Mail message body
Subject: Betreff
To:     Recipients <testuser@EGUVEN.LOCAL>
From:   Mavis@vger.kernel.org, Wancyzk@vger.kernel.org
Message-ID: <5169c9e6035f494e8e2d93581fcd98da@EGUVENEX.EGUVEN.LOCAL>
Date:   Tue, 1 Aug 2023 04:11:16 +0300
X-Originating-IP: [185.253.162.3]
X-ClientProxiedBy: EGUVENEX.EGUVEN.LOCAL (192.168.127.11) To
 EGUVENEX.EGUVEN.LOCAL (192.168.127.11)
X-Brightmail-Tracker: H4sIAAAAAAAAA02Ra0hTYRzGec857hwXq+MSfTFSmpJ2mwphb2qSKXQQIgk/9cXNPOlqczIt
        u5CXvOW0NNPSoVvZSpsaOuYlytty3tCaLVKxwpqNvJFXSoTKKZHfHp7n/zz84E/h/ErCjZIk
        JLOKBLFUwOESnTVp2w4ZXPpj/XK6g9C9qSwCGfWFJOoeWCJRy7wb6iwrBKj4QwNAWrWJREtD
        NhzVzzSRqPl2JYbSy6sd0PxYMYZejisB0vw5hUorMKRV1gJk+qV1QD3PlSRas+ZzkP77NH7c
        mWlcNgJGn32GeaH6RDI352wEYy0Y5DDdVe0EozVocGZqpRNnlOaTzOTbKYJZ0rsz47Zmgika
        tYJI3llucCwrlVxmFb4hIm58/VAhnjhMXKk0D+DpYA5XAkcK0oehqXiQVAIuxad1AN6ZSefY
        A5wWwtHSkg3No51gf/kksekfgE8fzayXqXW9F64ok+32TpqGs+PWjU3ndbulIwuzaw69E5ZZ
        2rDNmXBYZv0G7FU+LYCTtWfsNkF7wTfWXGITZw9s0DVunECahZPPgorAdtUWHtUWHtUWHtV/
        noeA0AFaJpZI/YVsjER4Ti4TJiv0YP2DdR7cmFZgMSwIjQCjgBFAChc483at9cbyebHiq9dY
        hTxacUnKJhnBLooQuPL89rVH8+k4cTJ7kWUTWcW/FKMc3dKxJpljlWhbBiw3NmVm31027/7q
        dSN/xXdA/bsvaOyo0fuohdtzS9J14mPFcG6dSMXTzNXGyR/PLnq1l2raPDLSUppWQ1okP0ld
        1WWZsqO/XnhkwXL6Ie98TM0rt6zMVXNwaHPB/df8teGw9xW+0z5HdIFTI98djO6ylNq1Yysi
        97oJtWhxwpPuy/ReLqAPXhrBzJrp0XcRXwLeP3D9nGl61mzKi+q7kNE6o635MmHjRIaTgRFd
        +e7SMMOILa+ooeSKy5NPE5wQw9h0Tm7oyHKdDk9N7Y247uQtkgcHSSqrJRVM1A9PW8AHn4Fx
        OTdhR6jay7XRxVIgy/IZKqN8BERSvNh/P65IEv8FqM/XFDADAAA=
X-Spam-Status: No, score=3.1 required=5.0 tests=BAYES_50,DATE_IN_PAST_12_24,
        FROM_ADDR_WS,LOTS_OF_MONEY,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

" <testuser@EGUVEN.LOCAL>
Date: Tue, 01 Aug 2023 02:11:12 +0100
Reply-To: wanczykmavis01@yahoo.com

Hallo, ich bin Frau Mavis Wancyzk, Sie haben eine Spende in Höhe von 4.800.000,00 EUR. Ich habe am 25. August 2017 den Powerball-Jackpot in Amerika im Wert von 759 Millionen US-Dollar gewonnen und spende einen Teil davon zum Gedenken an fünf glückliche Menschen und drei Unternehmen und Wohltätigkeitsheime mein Mann, der an Krebs gestorben ist. Kontaktieren Sie mich für weitere Details unter: 

E-Mail für weitere Informationen: wanczykmavis01@yahoo.com
