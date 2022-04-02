Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AF044F05BE
	for <lists+ceph-devel@lfdr.de>; Sat,  2 Apr 2022 21:20:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239683AbiDBTWP (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 2 Apr 2022 15:22:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbiDBTWO (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sat, 2 Apr 2022 15:22:14 -0400
X-Greylist: delayed 304 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 02 Apr 2022 12:20:22 PDT
Received: from mta-out-01.alice.it (mta-out-01.alice.it [217.169.118.7])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DCEE71B780
        for <ceph-devel@vger.kernel.org>; Sat,  2 Apr 2022 12:20:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alice.it; s=20211207; t=1648927222; 
        bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
        h=Reply-To:From:To:Date:Message-ID:MIME-Version;
        b=O/JlA7Xm4WjEnEM86+uNwMsY8X68xHhAIkX8oU/FskR/7KSXQ2fxZ47FAIGKrkhjbfNoz492/YKMaGIvXeVwhr/oALzVTsBMJHZ6QeU9QfL3bmN+AOa/uPRDzAbnTqzhN0MhaVXiS4WkWNT2mg7XJroNxmpclvzg73FBEf+oboxd8BSUo8pW0QGwksGjmHJ7tq3bTa8N53j0H1Q8p41o4vVWlsyhXDlomwCuCb1/r8UK17QaLDEfBfExcRzE8DG52teG6BgKwFXUtjWyttTLx9l8Om5NH900mHjP55PphvY33u6pSlmpXs95vYMVfaEpteXAUvisct5+MKYRZkEqkg==
X-RazorGate-Vade: gggruggvucftvghtrhhoucdtuddrgedvvddrudeikedgudefjecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfvgffngfevqffokffvtefnkfetpdfqfgfvnecuuegrihhlohhuthemuceftddunecugfhmphhthicushhusghjvggtthculddutddmnefgmhhpthihucgsohguhiculdehtddmnecujfgurheprhfhvfffkfggsedttdeftddttddtnecuhfhrohhmpeghvgcuhhgrvhgvucgrnhcuohhffhgvrhcuthhouchinhhvvghsthcuihhnucihohhurhcutghouhhnthhrhicuuhhnuggvrhcurgcujhhoihhnthcuvhgvnhhtuhhrvgcuphgrrhhtnhgvrhhshhhiphcuphhlvggrshgvuchrvghplhihuchfohhruchmohhrvgcuuggvthgrihhlshcuoehfpghpvghnnhgrsegrlhhitggvrdhitheqnecuggftrfgrthhtvghrnhepheejteeghfelteeitdekleffgfejueeggeelkeeufffggedtkeekieefvddvffetnecukfhppedujeeirddvvdejrddvgedvrdduledtnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehhvghloheprghlihgtvgdrihhtpdhinhgvthepudejiedrvddvjedrvdegvddrudeltddpmhgrihhlfhhrohhmpehfpghpvghnnhgrsegrlhhitggvrdhithdpnhgspghrtghpthhtohepuddprhgtphhtthhopegtvghphhdquggvvhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-RazorGate-Vade-Verdict: clean 60
X-RazorGate-Vade-Classification: clean
Received: from alice.it (176.227.242.190) by mta-out-01.alice.it (5.8.807.04) (authenticated as f_penna@alice.it)
        id 6244775000CFCA1D for ceph-devel@vger.kernel.org; Sat, 2 Apr 2022 21:15:17 +0200
Reply-To: dougfield20@inbox.lv
From:   We have an offer to invest in your country under a
         joint venture partnership please reply for more
         details <f_penna@alice.it>
To:     ceph-devel@vger.kernel.org
Date:   02 Apr 2022 12:15:15 -0700
Message-ID: <20220402121515.6A23DEAC71FA730C@alice.it>
MIME-Version: 1.0
X-Spam-Status: Yes, score=5.7 required=5.0 tests=BAYES_50,BODY_EMPTY,
        DKIM_INVALID,DKIM_SIGNED,EMPTY_MESSAGE,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,MISSING_SUBJECT,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_BL,RCVD_IN_MSPIKE_L3,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.7 RCVD_IN_DNSWL_LOW RBL: Sender listed at https://www.dnswl.org/,
        *       low trust
        *      [217.169.118.7 listed in list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5140]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [f_penna[at]alice.it]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [dougfield20[at]inbox.lv]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        *  0.0 RCVD_IN_MSPIKE_L3 RBL: Low reputation (-3)
        *      [217.169.118.7 listed in bl.mailspike.net]
        *  2.3 EMPTY_MESSAGE Message appears to have no textual parts and no
        *      Subject: text
        *  1.8 MISSING_SUBJECT Missing Subject: header
        *  0.1 DKIM_INVALID DKIM or DK signature exists, but is not valid
        *  0.0 RCVD_IN_MSPIKE_BL Mailspike blacklisted
        *  0.0 BODY_EMPTY No body text in message
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

