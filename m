Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E23E4D38FC
	for <lists+ceph-devel@lfdr.de>; Wed,  9 Mar 2022 19:40:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233398AbiCISkP (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 9 Mar 2022 13:40:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231868AbiCISkN (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 9 Mar 2022 13:40:13 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AF14D27A
        for <ceph-devel@vger.kernel.org>; Wed,  9 Mar 2022 10:39:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646851151;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TU5GSQcUsGsLm0QedmIo4Msii85jhaXsQwdtUQuJMSQ=;
        b=VZZiYWZf9hLa/81sh3aCS22+YFCVU6+XIUExDiFMVr9S1cE0THWv/F22FloPEvwU2Uof1Y
        lLdbzIHIUrxMFuoOz8Pf4bTCzw3DmSQcWsLgLMUQvANrsZyrYmTFy9MToRJPuXBOWMZqJ4
        EPf2eTxGwIXTcSxlUY/tVxn1otxIkwI=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-438-HY-3Gg-xMSi_hgdPXuTUgA-1; Wed, 09 Mar 2022 13:39:10 -0500
X-MC-Unique: HY-3Gg-xMSi_hgdPXuTUgA-1
Received: by mail-qk1-f197.google.com with SMTP id w200-20020a3762d1000000b0067d2149318dso2213239qkb.1
        for <ceph-devel@vger.kernel.org>; Wed, 09 Mar 2022 10:39:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=TU5GSQcUsGsLm0QedmIo4Msii85jhaXsQwdtUQuJMSQ=;
        b=WMiQwrohtBOtdemK6TxRPL8LIPYjIprxdEjn9YJg1m0P62FQsbXbscTyGs1LQKwx6V
         kN7FNw1Lzg0SxhEHAI7p8wpoqQLmpiGEOd03El03qsLLdysLmBV6PqLUunJCSy/h9v5u
         FzTmH8tEQx+7X9h76ayi7I/NntYwIEVf66dG4m+e6+ReIbEMhB8w9Da5nOksIYijbg94
         ZejN+xEbah2yIdH7LR9R5mzf0YWFbWO4mincaST5KWpS3kkk31AIy9MU4fElEEAlULfE
         p0Fr+xKj6VQK9YWop0DSJxA+Xvzz8Z9ZYwCnuaJBfJ8cBg6Zfhs2fZcxZF9jwFj5gDHT
         M2mQ==
X-Gm-Message-State: AOAM530HDl940y2tP0kUxDVLmk95TKuQnCQWGQWj2EUT5Yg0PS9RMm0P
        JoV5ZKg1czJOfObprq7+k4G9mL5beE+QcytkE7lskVrM2UzUuTmziz2rzn9vBeYzXlhrfdwOIIy
        D8OqHWBJP6FDDD2tNbpUgxA==
X-Received: by 2002:a05:6214:d44:b0:435:b8fd:b1d7 with SMTP id 4-20020a0562140d4400b00435b8fdb1d7mr808171qvr.19.1646851150318;
        Wed, 09 Mar 2022 10:39:10 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzICtIC42Xa9GHFyHP+MaqIARsvCbO2mnHxe/nMuAl463CulcS9BHk/JL6v+PefmyNOF/kr8A==
X-Received: by 2002:a05:6214:d44:b0:435:b8fd:b1d7 with SMTP id 4-20020a0562140d4400b00435b8fdb1d7mr808157qvr.19.1646851150152;
        Wed, 09 Mar 2022 10:39:10 -0800 (PST)
Received: from [192.168.1.3] (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id t7-20020a05622a180700b002e0ccf0aa49sm1829549qtc.62.2022.03.09.10.39.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 10:39:09 -0800 (PST)
Message-ID: <737c8db7461567ec04d5e2a7dbec58b699f8f16c.camel@redhat.com>
Subject: Re: [PATCH v2 02/19] netfs: Generate enums from trace symbol
 mapping lists
From:   Jeff Layton <jlayton@redhat.com>
To:     David Howells <dhowells@redhat.com>
Cc:     linux-cachefs@redhat.com,
        Anna Schumaker <anna.schumaker@netapp.com>,
        Steve French <sfrench@samba.org>,
        Dominique Martinet <asmadeus@codewreck.org>,
        David Wysochanski <dwysocha@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Jeffle Xu <jefflexu@linux.alibaba.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-afs@lists.infradead.org, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, ceph-devel@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Wed, 09 Mar 2022 13:39:08 -0500
In-Reply-To: <1712592.1646840957@warthog.procyon.org.uk>
References: <c2f4b3dc107b106e04c48f54945a12715cccfdf3.camel@redhat.com>
         <164678185692.1200972.597611902374126174.stgit@warthog.procyon.org.uk>
         <164678192454.1200972.4428834328108580460.stgit@warthog.procyon.org.uk>
         <1712592.1646840957@warthog.procyon.org.uk>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2022-03-09 at 15:49 +0000, David Howells wrote:
> Jeff Layton <jlayton@redhat.com> wrote:
> 
> > Should you undef EM and E_ here after creating these?
> 
> Maybe.  So far it hasn't mattered...
> 

I wasn't suggesting there was a bug there, more just a code hygiene
thing. With macro names as generic as that (especially), it'd probably
be good to undef them once you're done.
-- 
Jeff Layton <jlayton@redhat.com>

