Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9DE17B5C36
	for <lists+ceph-devel@lfdr.de>; Mon,  2 Oct 2023 22:46:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbjJBUqY (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 2 Oct 2023 16:46:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbjJBUqX (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 2 Oct 2023 16:46:23 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2D68BF
        for <ceph-devel@vger.kernel.org>; Mon,  2 Oct 2023 13:46:20 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id 4fb4d7f45d1cf-53627feca49so201168a12.1
        for <ceph-devel@vger.kernel.org>; Mon, 02 Oct 2023 13:46:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696279579; x=1696884379; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=YIDHazukaCr8c6bfGj5ZeaoapgBvDd8HlYiYQIfJWRE=;
        b=iSAgUQBrIiqOfoXRtuvXoIM0pVKOmCrQRt7rot/ATT2VOlanWgPHqhH/AppRFGXJi3
         0/PnawsCd1WgFw8KGSEFJbKVfg9rwaM9Gu5LjXY7p9JUxGGcr2pP3dltS2JJT0I9Xd5D
         EU8hJsLK2A8aXmwBAsnc15zBNY/vkac1GAGHy1SQsJiLlDEPFQGSb8yzKNqLa2cyTsWA
         zQ+qYIcWB/Xw3ZMKpmmnV5z3KY8kye1qWANFPOU8MGGs/dJWh2vsx2UZKeY5Ei87aERy
         L1lqpg+jSEa9Go0MfqtnViRkojfq8OMWO7nQ8gSE0sTpiAxG+XyUyZa0d+mtYuqN4szY
         lJRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696279579; x=1696884379;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YIDHazukaCr8c6bfGj5ZeaoapgBvDd8HlYiYQIfJWRE=;
        b=RzCC2h8bob+baiaepOAhr0dWxwb0xipB8jPYbIMnrodTETI+akZOt4jcG3Yp1Actmd
         U7IHxKeyv2V0Ax9N1ww/NUjnJHxJZm9kxtg8BxAZzxxFvjf4Pj7WboWOnN7dhh9kaaLo
         RKoRlShFGuE7x7LdB2e44wPUtHQs1Tugjfk6z1nbkEntAU7rX41q7u09oCH0IKDAsN5t
         2JSADVQVEjhcoZl/j9DGEbiuaMZjX/XQLfDQHeYaDCudzi5vMlGAzEEmYJGt4Fz6UNmd
         72g3UmmZ6/5ZBY+ZSSbMTlshOML54ORmbSieYRmZpMAhgQDmF183phUh0Rrp4swOAfmG
         0ZkQ==
X-Gm-Message-State: AOJu0YyPFZIEtkvZzTBvPmGyEaZqN4QU/Z5C/dS0OZpQ/E5oYLldV3sZ
        diL+J9KwMfKIa+v8bA+Fti63KLoQSD9hPPt42K4=
X-Google-Smtp-Source: AGHT+IHlXM5wEGhQ3oW0okd2LEIw0u5nG+15Qb+GO91HB6HnoCgGTM2j3EZwTOg5XU4b/yNxGzftUCgNJ4SQ8ysZlG0=
X-Received: by 2002:a17:906:32cb:b0:9aa:e07:d421 with SMTP id
 k11-20020a17090632cb00b009aa0e07d421mr10212634ejk.43.1696279579341; Mon, 02
 Oct 2023 13:46:19 -0700 (PDT)
MIME-Version: 1.0
From:   Hadley Maria <hadley.bussinessdatalist@gmail.com>
Date:   Mon, 2 Oct 2023 15:46:03 -0500
Message-ID: <CAAv3Yn4mDEnu090hd4pCkP-_deRzx_Rws_a6PBVKMj+dQQhiXg@mail.gmail.com>
Subject: RE: Verified APHA Attendees Mailing List 2023
To:     Hadley Maria <hadley.bussinessdatalist@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=2.6 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FILL_THIS_FORM,
        FILL_THIS_FORM_LONG,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi,

Would you be interested in acquiring American Public Health Attendees
Mailing List 2023?

List contains: Company Name, Contact Name, First Name, Middle Name,
Last Name, Title, Address, Street, City, Zip code, State, Country,
Telephone, Email address and more,

No of Contacts : - 17,857 Verified Contacts.
Cost: $1,677

Looking forward to hearing from you,

Kind Regards,
Hadley Maria
Marketing Coordinator
