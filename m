Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6E06728777
	for <lists+ceph-devel@lfdr.de>; Thu,  8 Jun 2023 20:48:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232255AbjFHSsL (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 8 Jun 2023 14:48:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231650AbjFHSsK (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 8 Jun 2023 14:48:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63F021FDF
        for <ceph-devel@vger.kernel.org>; Thu,  8 Jun 2023 11:47:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686250044;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type;
        bh=bIkL3j1SUti+mxRknWXsGzjEHfZ++LfAOrCAj6OvBfk=;
        b=Kn48uLCC+4ypR5THp/6vqzKM4u7WqxX2XSu0C+Xt/KU2vjTlcMA8cywiP3Da2zgYom7rYL
        V/HhDfxazhy3F7fur/HmFpOBjMeDhmkOBxio72cq5E0Hpzf39eqeKgYBxjDiF30/1NjH9V
        cp7jWEgr3EzJz7jLkUbRhbh7k2FeRik=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-468-luQDBngBOz-XZ0F86R0hgw-1; Thu, 08 Jun 2023 14:47:23 -0400
X-MC-Unique: luQDBngBOz-XZ0F86R0hgw-1
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-62856d3d316so12197216d6.1
        for <ceph-devel@vger.kernel.org>; Thu, 08 Jun 2023 11:47:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686250042; x=1688842042;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bIkL3j1SUti+mxRknWXsGzjEHfZ++LfAOrCAj6OvBfk=;
        b=SUUfTYVqEbFcz0oGEIWETuqki3vebqajZcVOgNGfdNpy3euUMqfLvoXh4VS/7+nUpd
         ckBxZtTZtehrdRZSyaBTGyqsqhjYvnaguTJ5k/qxj9qdYJEcc2wiR6rRmaWPXhGucSLL
         BUapnN1eFddQFLRFkbaVyi0aGeNDvTZUVYclWITOWNBQO63tQFO7FKXlHj4QcQgjjhuB
         2/C8ml8HJ9YdZHrZ07LLmyuJugrU2Ub9zkmTzXaA8E4bJae6UtZ6rs9a2UA8fNNdgFb3
         Y/Icq41MgN2CLPK7q8Txr4wSE0RKGO8Cal5fz0jVROkI/az6zJ0BeXeDqVAkUkoFKnRD
         Ah5A==
X-Gm-Message-State: AC+VfDwJnbGsKmJ7K4YKnw5hqSAyHjlUUIT4CMF+5CGDZ22tMPG1Va0T
        JHaACV4Fp9t/IbMEC8Hl8T0/Bfa/VvB/nBw2TwoNBqIifsobm077ixDRTMItWQqJC6KUoQZuJ6f
        RhPZQyu5HcvgPN7dExBZwfMnGFVMRRP9cVBevxZAVdj8/8w==
X-Received: by 2002:a05:6214:4013:b0:5ef:5e1b:a365 with SMTP id kd19-20020a056214401300b005ef5e1ba365mr2710103qvb.10.1686250042735;
        Thu, 08 Jun 2023 11:47:22 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ42HNRGWLp/yS8NSsCJvdnF+nWgvhAUkjlkkIfIeLvsaInPk0tiJ6PRvqqm/7KXBo6gJfVdO1f14QNgQvRKpyE=
X-Received: by 2002:a05:6214:4013:b0:5ef:5e1b:a365 with SMTP id
 kd19-20020a056214401300b005ef5e1ba365mr2710095qvb.10.1686250042548; Thu, 08
 Jun 2023 11:47:22 -0700 (PDT)
MIME-Version: 1.0
From:   Patrick Donnelly <pdonnell@redhat.com>
Date:   Thu, 8 Jun 2023 14:46:56 -0400
Message-ID: <CA+2bHPbCbSaPKrYKhMTn9+Ms8XOzTbs6BNsYzrTdW8hG62=UQg@mail.gmail.com>
Subject: 
To:     Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        TVD_SPACE_RATIO,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

subscribe

