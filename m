Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 965703378FA
	for <lists+ceph-devel@lfdr.de>; Thu, 11 Mar 2021 17:15:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234525AbhCKQPI (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 11 Mar 2021 11:15:08 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:34273 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234356AbhCKQOn (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 11 Mar 2021 11:14:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615479283;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=5BdqRRaNJL3W0J+WwpFWzd8HKyojygm61onRnLWcdew=;
        b=LUAmkOsyjprAXGFdLhYhJy9aCaGP7JRM1CBajp3PnCTSe507wrgllL/ON0FawmaLBARILi
        9dJc3XpvzF5Xh9MVwPUTKLknqnkAMMqwmtbrh8E41MBj8DbhNhZ0vnqRFhcqDouWE4NttQ
        NkNfP/SppYZI3Zz6wtLBzSIp/RJES7A=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-362-sVuMgVcfODub_Sn-jsPVeA-1; Thu, 11 Mar 2021 11:14:41 -0500
X-MC-Unique: sVuMgVcfODub_Sn-jsPVeA-1
Received: by mail-qk1-f199.google.com with SMTP id k68so15888507qke.2
        for <ceph-devel@vger.kernel.org>; Thu, 11 Mar 2021 08:14:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:date:user-agent
         :mime-version:content-transfer-encoding;
        bh=5BdqRRaNJL3W0J+WwpFWzd8HKyojygm61onRnLWcdew=;
        b=rH0sINeBnkZC1xdOd8XrxzZZv5Rg3Z4nSLDVeMoSQsOaMjxsHipeSHIHj52QS1fH66
         iIwKv2IbdIl2X8ous7/8zcR3HyZge1Ew70pg9L2HpyzdAlUwP0vWSDzOQst/Oirjuipi
         +ja5u43aPsCucsDadwtYyG//TyEH/13pjWqnRoUHELl8H9lwuZP2al6B8K2T0QjBtI4U
         WEs693k4VGJbHxeoMpvVnKIHoCUM+6BBSbej7rrA2VZhvT8uTYHyMZCvkDKP1nP4G2Bk
         8fMys9R5qamNEJs9PZyxhKz8AF5ScdaX96F6iJz6gpnZMaAJOxyc0rtP2zJ3vZSNVCfY
         z/AQ==
X-Gm-Message-State: AOAM533Gt+mZhZG7Vvy4TtX+zewh0vzTQNHvZ37fDEiDPZWIW6cVq3tm
        t7G02GSEZ2PirWz7Ebooeq/MrHydr4ltf2Dv3P+G98QCIwC81lja0++LAz5VhuwInL0LOMlVL7m
        PJG9wOo5Z28EFVnWUlEIzaQ==
X-Received: by 2002:ac8:7c8d:: with SMTP id y13mr4914164qtv.294.1615479280683;
        Thu, 11 Mar 2021 08:14:40 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyRMRYfAIV82zGHdXhXruDibk2ojeDJGB6PY10tLTMddbpGcPzmGzW/DSvfWmpDNK+5hw/E/w==
X-Received: by 2002:ac8:7c8d:: with SMTP id y13mr4914146qtv.294.1615479280418;
        Thu, 11 Mar 2021 08:14:40 -0800 (PST)
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id g14sm2164823qkm.98.2021.03.11.08.14.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Mar 2021 08:14:39 -0800 (PST)
Message-ID: <10fa59845ccb872620cc91d8ec7378302cb44cda.camel@redhat.com>
Subject: fscrypt and file truncation on cephfs
From:   Jeff Layton <jlayton@redhat.com>
To:     dev <dev@ceph.io>,
        "open list:CEPH DISTRIBUTED..." <ceph-devel@vger.kernel.org>
Date:   Thu, 11 Mar 2021 11:14:39 -0500
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

tl;dr version: in cephfs, the MDS handles truncating object data when
inodes are truncated. This is problematic with fscrypt.

Longer version:

I've been working on a patchset to add fscrypt support to kcephfs, and
have hit a problem with the way that truncation is handled. The main
issue is that fscrypt uses block-based ciphers, so we must ensure that
we read and write complete crypto blocks on the OSDs.

I'm currently using 4k crypto blocks, but we may want to allow this to
be tunable eventually (though it will need to be smaller than and align
with the OSD object size). For simplicity's sake, I'm planning to
disallow custom layouts on encrypted inodes. We could consider adding
that later (but it doesn't sound likely to be worthwhile).

Normally, when a file is truncated (usually via a SETATTR MDS call), the
MDS handles truncating or deleting objects on the OSDs. This is done
somewhat lazily in that the MDS replies to the client before this
process is complete (AFAICT).

Once we add fscrypt support, the MDS handling truncation becomes a
problem, in that we need to be able to deal with complete crypto blocks.
Letting the MDS truncate away part of a block will leave us with a block
that can't be decrypted.

There are a number of possible approaches to fixing this, but ultimately
the client will have to zero-pad, encrypt and write the blocks at the
edges since the MDS doesn't have access to the keys.

There are several possible approaches that I've identified:

1/ We could teach the MDS the crypto blocksize, and ensure that it
doesn't truncate away partial blocks. The client could tell the MDS what
blocksize it's using on the inode and the MDS could ensure that
truncates align to the blocks. The client will still need to write
partial blocks at the edges of holes or at the EOF, and it probably
shouldn't do that until it gets the unstable reply from the MDS. We
could handle this by adding a new truncate op or extending the existing
one.

2/ We could cede the object truncate/delete to the client altogether.
The MDS is aware when an inode is encrypted so it could just not do it
for those inodes. We also already handle hole punching completely on the
client (though the size doesn't change there). Truncate could be a
special case of that. Probably, the client would issue the truncate and
then be responsible for deleting/rewriting blocks after that reply comes
in. We'd have to consider how to handle delinquent clients that don't
clean up correctly.

3/ We could maintain a separate field in the inode for the real
inode->i_size that crypto-enabled clients would use. The client would
always communicate a size to the MDS that is rounded up to the end of
the last crypto block, such that the "true" size of the inode on disk
would always be represented in the rstats. Only crypto-enabled clients
would care about the "realsize" field. In fact, this value could
_itself_ be encrypted too, so that the i_size of the file is masked from
clients that don't have keys.

Ceph's truncation machinery is pretty complex in general, so I could
have missed other approaches or something that makes these ideas
impossible. I'm leaning toward #3 here since I think it has the most
benefit and keeps the MDS out of the whole business.

What should we do here?
-- 
Jeff Layton <jlayton@redhat.com>

