Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C27A7B8C7D
	for <lists+ceph-devel@lfdr.de>; Wed,  4 Oct 2023 21:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245202AbjJDTNN (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 4 Oct 2023 15:13:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245244AbjJDTNI (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 4 Oct 2023 15:13:08 -0400
Received: from mail-oa1-x41.google.com (mail-oa1-x41.google.com [IPv6:2001:4860:4864:20::41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EEA31A7
        for <ceph-devel@vger.kernel.org>; Wed,  4 Oct 2023 12:13:00 -0700 (PDT)
Received: by mail-oa1-x41.google.com with SMTP id 586e51a60fabf-1e1b1b96746so53587fac.2
        for <ceph-devel@vger.kernel.org>; Wed, 04 Oct 2023 12:13:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=healthydataprovider.com; s=google; t=1696446779; x=1697051579; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=cDrS5JEBq0r4nYeeAvnF79Wt86fu+a+uZWnoO4JTUAI=;
        b=EGBkjyTORgywlHAmv+/aRkDTx1rY03fezMq94YXbq8+piZ4C5EGE0ke2LygVpJf0hB
         GsOJnrtXP4XjURec0f4/wEoNhtzhConvtwaFL/rLCX6QcshFr5odRMQIW3X8q2fyZHvW
         QKPyRN0R9kVL2O2lmvkfPQ/wxTXYag2cHTqRSji1pcx31NomQGW13gnq6CegPfBiDUFA
         THfsgEupV3ROBSc8pDcijLgdqqlvtOsPq15x7vSwsABzqXZORbycyl96LhrPC+xnBeYK
         v1lAEH8D9UiTRdjtsCBFrCjlaCSamnqFInd2I6/+EAXwNTTfQ3/fDFWoXZnZ4izuSwqT
         HXFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696446779; x=1697051579;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cDrS5JEBq0r4nYeeAvnF79Wt86fu+a+uZWnoO4JTUAI=;
        b=ZnCPo9DlVr6eFV8iZSOoaeogsAjCCCvOUaxM5PE3g+drWXHUA8BtxOt6zw1k+fP+Od
         buiuc0wB1fqFmYCS4UkLg+JJoVWAqZofmgPbArwo7oC7GAZmszX6DKw8Vq3nkP/xLl2F
         aawrLe9plzwA1b3kLOnJfPDUglqvhAqF8A8luNgbL2ObGSfnS5aIMSteZyjMl/J+lYDg
         zSIGL0tprwbwx/BYzq5TGUUF64I1UBRYT8/h6yf08VMlsikezp+HUSOKJBbaiuaNSe0o
         KY/5nTt2y7IhNkxw52e//JWnZCGFmwT3ZMhSpc1DECNnu82OKJYXisgm2aX2/CeYC+gP
         kFwQ==
X-Gm-Message-State: AOJu0YyxpLkZKdDrzmrRBPR6mm0p73wHAzHYObkj7z/hpBFPrCkSsV7S
        eaYv6LCatjPAYbeZus4+J4Spp1eJJFZR8EJ6xUWFTQ==
X-Google-Smtp-Source: AGHT+IHgCxncg9f0dm2tLk0LmlPOHUHVjrk98NrZU7RxgLCnBzuBYIUFxGL4uFKMM/6cR1jeKF4gSBELqkoyMSFYkT8=
X-Received: by 2002:a05:6870:8301:b0:1d5:a303:5f56 with SMTP id
 p1-20020a056870830100b001d5a3035f56mr3445725oae.21.1696446779466; Wed, 04 Oct
 2023 12:12:59 -0700 (PDT)
MIME-Version: 1.0
From:   Rose Frank <rose@healthydataprovider.com>
Date:   Wed, 4 Oct 2023 14:12:47 -0500
Message-ID: <CAEBxSDwp7h-MNDnAQb35Sd0iu9CkQNmFLSk5Yu=rZRo+xYyHxg@mail.gmail.com>
Subject: RE: Money20/20 USA in Las Vegas Attendees Data-List 2023
To:     Rose Frank <rose@healthydataprovider.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.6 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi,

Would you be interested in acquiring Money20/20 USA Email List?

Number of Contacts: 11,542
Cost: $ 1,687

Interested? Email me back; I would love to provide more information on the list.

Kind Regards,
Rose Frank
Marketing Coordinator
